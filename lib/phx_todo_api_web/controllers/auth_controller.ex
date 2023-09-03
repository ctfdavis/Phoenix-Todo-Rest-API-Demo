defmodule PhxTodoApiWeb.AuthController do
  use PhxTodoApiWeb, :controller
  alias PhxTodoApiWeb.Token

  def login(conn, %{"username" => username, "password" => password}) do
    # TODO: check that this user exists
    # TODO: check that the plain password matches the hashed password
    IO.puts("username: #{username}, password: #{password}")
    {:ok, token, claims} = Token.generate_and_sign()

    conn
    |> put_status(:ok)
    |> render(:login, token: token)
  end
end
