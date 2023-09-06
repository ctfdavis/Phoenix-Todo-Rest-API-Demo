defmodule PhxTodoApiWeb.TodoController do
  use PhxTodoApiWeb, :controller

  alias PhxTodoApi.Todos
  alias PhxTodoApi.Todos.Todo

  action_fallback PhxTodoApiWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns[:user_id]
    todos = Todos.list_todos_by_user_id(user_id)
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Todo{} = todo} <- Todos.create_todo(Map.put(todo_params, "user_id", user_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo}")
      |> render(:show, todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    IO.inspect(conn.assigns)
    user_id = conn.assigns[:user_id]
    IO.puts("user_id: #{user_id}")

    with {:ok, %Todo{} = todo} <- Todos.get_todo_by_id_and_user_id(id, user_id) do
      render(conn, :show, todo: todo)
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Todo{} = todo} <- Todos.get_todo_by_id_and_user_id(id, user_id),
         {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns[:user_id]

    with {:ok, %Todo{} = todo} <- Todos.get_todo_by_id_and_user_id(id, user_id),
         {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
