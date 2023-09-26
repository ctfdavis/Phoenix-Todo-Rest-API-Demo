defmodule PhxTodoApiWeb.Auth.AccessValidator do
  import Plug.Conn
  require PhxTodoApi.Errors
  alias PhxTodoApiWeb.Auth
  alias PhxTodoApi.Errors
  alias PhxTodoApiWeb.FallbackController

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token | _] ->
        case Auth.validate_access_token(token) do
          {:ok, %{id: user_id} = _user} ->
            conn |> assign(:user_id, user_id)

          error ->
            handle_error(conn, error)
        end

      _ ->
        handle_error(conn, Errors.error_invalid_token())
    end
  end

  defp handle_error(conn, error) do
    FallbackController.call(conn, error)
    |> halt()
  end
end
