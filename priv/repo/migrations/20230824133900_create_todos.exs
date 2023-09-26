defmodule PhxTodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string
      add :completed, :boolean, default: false, null: false

      add :user_id, references("users", on_delete: :delete_all, on_update: :update_all),
        null: false

      timestamps()
    end
  end
end
