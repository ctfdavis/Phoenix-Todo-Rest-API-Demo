defmodule PhxTodoApi.Repo.Migrations.CreateUsersEmailLog do
  use Ecto.Migration

  def change do
    create table(:users_email_log) do
      add :type, :string, null: false
      add :sent_at, :naive_datetime, default: fragment("now()"), null: false

      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all),
        null: false
    end

    create index(:users_email_log, [:user_id])
  end
end
