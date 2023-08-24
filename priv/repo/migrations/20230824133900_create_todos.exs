defmodule PhxTodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string
      add :completed, :boolean, default: false, null: false
      add :tags, {:array, :string}

      timestamps()
    end
  end
end
