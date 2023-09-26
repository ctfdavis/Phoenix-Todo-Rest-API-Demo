defmodule PhxTodoApi.Users.EmailLog do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhxTodoApi.Users.User

  schema "users_email_log" do
    field :type, :string
    field :sent_at, :naive_datetime
    belongs_to :user, User
  end

  @doc false
  def changeset(email_log, attrs) do
    email_log
    |> cast(attrs, [:type, :sent_at, :user_id])
    |> validate_required([:type, :user_id])
  end
end
