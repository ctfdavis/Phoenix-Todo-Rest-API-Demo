defmodule PhxTodoApiWeb.AuthController do
  use PhxTodoApiWeb, :controller
  alias PhxTodoApiWeb.Token
  alias PhxTodoApi.Users
  alias PhxTodoApi.Users.User

  action_fallback PhxTodoApiWeb.FallbackController

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, %User{} = user} <- Users.get_user_by(email: username) do
      if Argon2.verify_pass(password, user.password_hash) do
        {:ok, token, _claims} = Token.generate_and_sign(%{"user_id" => user.id})

        conn
        |> put_status(:ok)
        |> render(:login, token: token)
      else
        Users.user_not_found()
      end
    end
  end
end
