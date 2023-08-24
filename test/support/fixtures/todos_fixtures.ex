defmodule PhxTodoApi.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxTodoApi.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
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
end
