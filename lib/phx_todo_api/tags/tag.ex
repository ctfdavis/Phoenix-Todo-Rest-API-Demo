defmodule PhxTodoApi.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhxTodoApi.Users.User
  alias PhxTodoApi.Todos.Todo

  schema "tags" do
    field :name, :string
    belongs_to :user, User
    many_to_many :todos, Todo, join_through: "todos_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
