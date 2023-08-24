defmodule PhxTodoApiWeb.TodoController do
  use PhxTodoApiWeb, :controller

  alias PhxTodoApi.Todos
  alias PhxTodoApi.Todos.Todo

  action_fallback PhxTodoApiWeb.FallbackController

  def index(conn, _params) do
    todos = Todos.list_todos()
    render(conn, :index, todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo}")
      |> render(:show, todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Todo{} = todo} <- Todos.get_todo(id) do
      render(conn, :show, todo: todo)
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <- Todos.get_todo(id),
         {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Todo{} = todo} <- Todos.get_todo(id),
         {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
