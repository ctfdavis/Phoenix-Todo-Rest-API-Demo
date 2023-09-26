defmodule PhxTodoApi.Repo.Migrations.CreateTodosTags do
  use Ecto.Migration

  def change do
    create table(:todos_tags) do
      add :todo_id, references(:todos, on_delete: :delete_all, on_update: :update_all),
        null: false

      add :tag_id, references(:tags, on_delete: :delete_all, on_update: :update_all), null: false
    end

    create index(:todos_tags, [:todo_id])
    create index(:todos_tags, [:tag_id])
    create unique_index(:todos_tags, [:todo_id, :tag_id])
  end
end
