defmodule PhxTodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :name, :string
    field :completed, :boolean, default: false
    field :tags, {:array, :string}
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name, :completed, :tags, :user_id])
    |> validate_required([:name, :completed, :user_id])
  end
end
