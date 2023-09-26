defmodule PhxTodoApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PhxTodoApiWeb, :controller
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PhxTodoApiWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, error) when error == Errors.error_tag_not_found() do
    conn
    |> put_status(:not_found)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.tag_not_found())
  end

  def call(conn, error) when error == Errors.error_todo_not_found() do
    conn
    |> put_status(:not_found)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.todo_not_found())
  end

  def call(conn, error) when error == Errors.error_user_not_found() do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.user_not_found())
  end

  def call(conn, error) when error == Errors.error_user_not_activated() do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.user_not_activated())
  end

  def call(conn, error) when error == Errors.error_user_already_activated() do
    conn
    |> put_status(:conflict)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.user_already_activated())
  end

  def call(conn, error) when error == Errors.error_invalid_token() do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.invalid_token())
  end

  def call(conn, error) when error == Errors.error_too_many_requests() do
    conn
    |> put_status(:too_many_requests)
    |> put_view(json: PhxTodoApiWeb.ErrorJSON)
    |> render(Errors.too_many_requests())
  end
end
