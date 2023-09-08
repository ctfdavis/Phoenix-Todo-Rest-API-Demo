defmodule PhxTodoApiWeb.AuthController do
  use PhxTodoApiWeb, :controller
  alias PhxTodoApiWeb.Token
  alias PhxTodoApi.Users
  alias PhxTodoApi.Users.User

  action_fallback PhxTodoApiWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Users.get_user_by_email(email) do
      if Argon2.verify_pass(password, user.password_hash) do
        handle_login(conn, user.id)
      else
        Users.error_user_not_found()
      end
    end
  end

  def register(conn, user_params) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      handle_login(conn, user.id)
    end
  end

  defp handle_login(conn, user_id) do
    {:ok, token, _claims} = Token.generate_and_sign(%{"user_id" => user_id})

    conn
    |> put_status(:ok)
    |> render(:login, token: token)
  end
end
