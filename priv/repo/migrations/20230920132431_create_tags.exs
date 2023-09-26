defmodule PhxTodoApi.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string

      add :user_id, references("users", on_delete: :delete_all, on_update: :update_all),
        null: false

      timestamps()
    end

    create index(:tags, [:user_id])
    create unique_index(:tags, [:name, :user_id])
  end
end
