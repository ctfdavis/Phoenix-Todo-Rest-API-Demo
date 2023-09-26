defmodule PhxTodoApiWeb.PageController do
  alias PhxTodoApiWeb.Auth
  use PhxTodoApiWeb, :controller
  import Ecto.Changeset, only: [change: 1]

  def index(conn, _params) do
    render(conn, :index)
  end

  def password_reset(conn, %{"token" => token} = _params) do
    case Auth.validate_password_reset_token(token) do
      {:ok, %{email: email} = user} ->
        render(conn, :password_reset,
          token: token,
          email: email,
          changeset: change(user)
        )

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid token")
        |> redirect(to: ~p"/")
    end
  end

  def activate(conn, %{"token" => token} = _params) do
    case Auth.validate_activation_token(token) do
      {:ok, _} ->
        render(conn, :activate, token: token)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid token")
        |> redirect(to: ~p"/")
    end
  end
end
