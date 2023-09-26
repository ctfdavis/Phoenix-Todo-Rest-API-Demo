defmodule PhxTodoApi.Todos.Tags do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos_tags" do
    field :todo_id, :id
    field :tag_id, :id
  end

  @doc false
  def changeset(tags, attrs) do
    tags
    |> cast(attrs, [])
    |> validate_required([])
  end
end
