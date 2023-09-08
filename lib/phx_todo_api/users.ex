defmodule PhxTodoApi.Users do
  import Ecto.Query, warn: false
  alias PhxTodoApi.Repo
  alias PhxTodoApi.Users.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> error_user_not_found()
      user -> {:ok, user}
    end
  end

  def error_user_not_found do
    {:error, :user_not_found}
  end
end
