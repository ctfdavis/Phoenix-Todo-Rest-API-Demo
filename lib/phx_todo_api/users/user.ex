defmodule PhxTodoApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias PhxTodoApi.Repo

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :is_activated, :boolean, default: false
    field :last_activation_sent_at, :naive_datetime, virtual: true
    field :last_password_reset_sent_at, :naive_datetime, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :is_activated])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
      message: "invalid email"
    )
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def load_last_activation_sent_at(user) do
    query =
      from u in "users",
        join: e in "users_email_log",
        on: e.user_id == u.id,
        where: e.type == "activation" and u.id == ^user.id,
        select: max(e.sent_at)

    last_activation_sent_at = Repo.one(query)

    %{user | last_activation_sent_at: last_activation_sent_at}
  end

  def load_last_password_reset_sent_at(user) do
    query =
      from u in "users",
        join: e in "users_email_log",
        on: e.user_id == u.id,
        where: e.type == "password_reset" and u.id == ^user.id,
        select: max(e.sent_at)

    last_password_reset_sent_at = Repo.one(query)

    %{user | last_password_reset_sent_at: last_password_reset_sent_at}
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
