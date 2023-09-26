defmodule PhxTodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhxTodoApi.Users.User
  alias PhxTodoApi.Tags.Tag

  schema "todos" do
    field :name, :string
    field :completed, :boolean, default: false
    belongs_to :user, User
    many_to_many :tags, Tag, join_through: "todos_tags"

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name, :completed, :user_id])
    |> validate_required([:name, :completed, :user_id])
  end
end
