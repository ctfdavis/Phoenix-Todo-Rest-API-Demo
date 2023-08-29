defmodule PhxTodoApiWeb.Auth do
  import Plug.Conn
  alias PhxTodoApiWeb.Token

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    verified_conn =
      case get_req_header(conn, "authorization") do
        ["Bearer " <> token | _] ->
          with {:ok, claims} <- Token.verify(token) do
            conn
            |> assign(:current_user, claims)
          end

        _ ->
          {:error, :unauthorized}
      end

    case verified_conn do
      %Plug.Conn{} = conn -> conn
      {:error, reason} -> handle_error(conn, reason)
    end
  end

  defp handle_error(conn, reason) do
    conn
    |> send_resp(401, reason)
    |> halt()
  end
end
