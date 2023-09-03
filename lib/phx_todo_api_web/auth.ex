defmodule PhxTodoApiWeb.Auth do
  import Plug.Conn
  alias PhxTodoApiWeb.Token

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token | _] ->
        case Token.verify_and_validate(token) do
          {:ok, claims} -> conn |> assign(:current_user, claims)
          _ -> handle_error(conn)
        end

      _ ->
        handle_error(conn)
    end
  end

  defp handle_error(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
