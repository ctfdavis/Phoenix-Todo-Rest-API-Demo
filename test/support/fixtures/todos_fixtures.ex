defmodule PhxTodoApi.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxTodoApi.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{})

  def todo_fixture(%{user_id: _user_id} = attrs) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        name: "some name",
        completed: true,
        tags: ["option1", "option2"]
      })
      |> PhxTodoApi.Todos.create_todo()

    todo
  end

  def todo_fixture(attrs) do
    user = PhxTodoApi.UsersFixtures.user_fixture()

    todo_fixture(Map.put(attrs, :user_id, user.id))
  end
end
