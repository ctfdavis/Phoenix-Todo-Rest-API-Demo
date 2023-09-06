defmodule PhxTodoApi.Repo.Migrations.UpdateTodosTable do
  use Ecto.Migration

  def change do
    alter table("todos") do
      add :user_id, references("users", on_delete: :delete_all, on_update: :update_all),
        null: false
    end
  end
end
