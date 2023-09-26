defmodule PhxTodoApi.Users do
  import Ecto.Query, warn: false
  alias PhxTodoApi.Repo
  alias PhxTodoApi.Users.User
  alias PhxTodoApi.Users.EmailLog
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def activate_user(user) do
    query =
      from(
        u in User,
        where: u.id == ^user.id and u.is_activated == false,
        update: [set: [is_activated: true]]
      )

    case Repo.update_all(query, []) do
      {1, _} -> {:ok, user}
      {0, _} -> Errors.error_user_already_activated()
    end
  end

  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> Errors.error_user_not_found()
      user -> {:ok, user}
    end
  end

  def get_user_by_id(id) do
    case Repo.get(User, id) do
      nil -> Errors.error_user_not_found()
      user -> {:ok, user}
    end
  end

  defdelegate load_last_activation_sent_at(user), to: User
  defdelegate load_last_password_reset_sent_at(user), to: User

  def update_last_activation_sent_at(user) do
    update_email_sent_at(user, "activation")
  end

  def update_last_password_reset_sent_at(user) do
    update_email_sent_at(user, "password_reset")
  end

  defp update_email_sent_at(user, type) do
    %EmailLog{}
    |> EmailLog.changeset(%{user_id: user.id, type: type})
    |> Repo.insert()
  end
end
