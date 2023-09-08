defmodule PhxTodoApiWeb.TodoControllerTest do
  use PhxTodoApiWeb.ConnCase

  import PhxTodoApi.TodosFixtures
  import PhxTodoApi.UsersFixtures

  alias PhxTodoApi.Todos.Todo
  alias PhxTodoApiWeb.Token

  @create_attrs %{
    name: "some name",
    completed: true,
    tags: ["option1", "option2"]
  }
  @update_attrs %{
    name: "some updated name",
    completed: false,
    tags: ["option1"]
  }
  @invalid_attrs %{name: nil, completed: nil, tags: nil}

  setup %{conn: conn} do
    result = create_todo(conn)
    %{result | conn: put_req_header(result.conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = put_token_by_user_id(conn, user_fixture(%{email: "test_lists_todo@example.com"}).id)
      conn = get(conn, ~p"/api/todos")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/todos", todo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/todos/#{id}")

      assert %{
               "id" => ^id,
               "completed" => true,
               "name" => "some name",
               "tags" => ["option1", "option2"]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/todos", todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn = put(conn, ~p"/api/todos/#{todo}", todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/todos/#{id}")

      assert %{
               "id" => ^id,
               "completed" => false,
               "name" => "some updated name",
               "tags" => ["option1"]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, ~p"/api/todos/#{todo}", todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, ~p"/api/todos/#{todo}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/todos/#{todo}")
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  defp create_todo(conn) do
    user = user_fixture()
    todo = todo_fixture(%{user_id: user.id})

    %{
      conn: put_token_by_user_id(conn, user.id),
      todo: todo,
      user: user
    }
  end

  defp put_token_by_user_id(conn, user_id) do
    put_req_header(
      conn,
      "authorization",
      "Bearer #{Token.generate_and_sign!(%{"user_id" => user_id})}"
    )
  end
end
