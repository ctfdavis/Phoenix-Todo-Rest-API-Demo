defmodule PhxTodoApiWeb.AuthController do
  use PhxTodoApiWeb, :controller
  alias PhxTodoApiWeb.Token
  alias PhxTodoApi.Users
  alias PhxTodoApi.Users.User

  def login(conn, %{"username" => username, "password" => password}) do
    # TODO: check that this user exists
    # TODO: check that the plain password matches the hashed password
    IO.puts("username: #{username}, password: #{password}")

    with {:ok, user} <- Users.get_user_by(email: username) do
    end

    {:ok, token, claims} = Token.generate_and_sign()
    Now

    conn
    |> put_status(:ok)
    |> render(:login, token: token)
  end
end
