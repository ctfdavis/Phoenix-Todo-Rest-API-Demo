defmodule PhxTodoApi.Users do
  import Ecto.Query, warn: false
  alias PhxTodoApi.Repo
  alias PhxTodoApi.Users.User

  def get_user_by(queryable) do
    case Repo.get_by(User, queryable) do
      nil -> user_not_found()
      user -> {:ok, user}
    end
  end

  def user_not_found do
    {:error, :user_not_found}
  end
end
