defmodule PhxTodoApi.Repo do
  use Ecto.Repo,
    otp_app: :phx_todo_api,
    adapter: Ecto.Adapters.Postgres
end
