defmodule PhxTodoApi.TodosTest do
  use PhxTodoApi.DataCase

  alias PhxTodoApi.Todos

  describe "todos" do
    alias PhxTodoApi.Todos.Todo

    import PhxTodoApi.TodosFixtures

    @invalid_attrs %{name: nil, completed: nil, tags: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo(todo.id) == {:ok, todo}
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{name: "some name", completed: true, tags: ["option1", "option2"]}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.name == "some name"
      assert todo.completed == true
      assert todo.tags == ["option1", "option2"]
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{name: "some updated name", completed: false, tags: ["option1"]}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.name == "some updated name"
      assert todo.completed == false
      assert todo.tags == ["option1"]
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert {:ok, todo} == Todos.get_todo(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert {:error, :todo_not_found} = Todos.get_todo(todo.id)
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
