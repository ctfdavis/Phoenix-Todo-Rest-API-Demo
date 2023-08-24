defmodule PhxTodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :name, :string
    field :completed, :boolean, default: false
    field :tags, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name, :completed, :tags])
    |> validate_required([:name, :completed, :tags])
  end
end
