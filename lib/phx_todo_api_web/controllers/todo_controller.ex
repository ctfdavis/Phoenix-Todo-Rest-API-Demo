defmodule PhxTodoApiWeb.TodoController do
  use PhxTodoApiWeb, :controller
  require Logger

  alias PhxTodoApi.Todos
  alias PhxTodoApi.Todos.Todo
  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.{Schema}
  alias PhxTodoApiWeb.Schemas

  tags ["Todos"]
  security [%{"authorization" => []}]

  action_fallback PhxTodoApiWeb.FallbackController

  operation :index,
    summary: "List todos of signed in user",
    parameters: [
      "tag_ids[]": [
        in: :query,
        description: "Tag ids",
        required: false,
        type: %Schema{type: :array, items: %Schema{type: :integer, minimum: 1}}
      ]
    ],
    responses: [
      ok: {"Todo listing response", "application/json", Schemas.TodoListingResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def index(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"tag_ids" => tag_ids} = _param
      )
      when is_list(tag_ids) do
    Logger.debug("tag_ids: #{inspect(tag_ids)}")
    todos = Todos.list_todos_by_user_id_and_tag_ids(user_id, tag_ids)
    render(conn, :index, todos: todos)
  end

  def index(
        %Plug.Conn{assigns: %{user_id: _user_id}} = conn,
        _param
      ) do
    index(conn, %{"tag_ids" => []})
  end

  operation :create,
    summary: "Create a todo item for signed in user",
    request_body: {
      "Create todo params",
      "application/json",
      Schemas.TodoParams
    },
    responses: [
      created: {"Todo response", "application/json", Schemas.TodoResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def create(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"todo" => todo_params}
      ) do
    with {:ok, %Todo{} = todo} <- Todos.create_todo(Map.put(todo_params, "user_id", user_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todos/#{todo}")
      |> render(:show, todo: todo)
    end
  end

  operation :show,
    summary: "Get a todo item by id owned by signed in user",
    parameters: [
      id: [in: :path, description: "Todo id", required: true, type: :integer, example: 1]
    ],
    responses: [
      ok: {"Todo response", "application/json", Schemas.TodoResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      not_found: {"Todo not found", "application/json", Schemas.ErrorResponse}
    ]

  def show(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"id" => id}
      ) do
    with {:ok, %Todo{} = todo} <- Todos.get_todo_by_id_and_user_id(id, user_id) do
      render(conn, :show, todo: todo)
    end
  end

  operation :update,
    summary: "Update a todo item by id owned by signed in user",
    parameters: [
      id: [in: :path, description: "Todo id", required: true, type: :integer, example: 1]
    ],
    request_body: {
      "Update todo params",
      "application/json",
      Schemas.TodoParams
    },
    responses: [
      ok: {"Todo response", "application/json", Schemas.TodoResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      not_found: {"Todo not found", "application/json", Schemas.ErrorResponse}
    ]

  def update(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"id" => id, "todo" => todo_params}
      ) do
    with {:ok, %Todo{} = todo} <- Todos.get_todo_by_id_and_user_id(id, user_id),
         {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, :show, todo: todo)
    end
  end

  operation :delete,
    summary: "Delete a todo item by id owned by signed in user",
    parameters: [
      id: [in: :path, description: "Todo id", required: true, type: :integer, example: 1]
    ],
    responses: [
      no_content: {"No content", "application/json", nil},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      not_found: {"Todo not found", "application/json", Schemas.ErrorResponse}
    ]

  def delete(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"id" => id}
      ) do
    with {:ok, %Todo{} = todo} <- Todos.get_todo_by_id_and_user_id(id, user_id),
         {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
