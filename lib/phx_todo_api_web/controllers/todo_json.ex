defmodule PhxTodoApiWeb.TodoJSON do
  import PhxTodoApiWeb.JSONResponse, only: [ok: 1]
  alias PhxTodoApi.Todos.Todo

  @doc """
  Renders a list of todos.
  """
  def index(%{todos: todos}) do
    ok(for(todo <- todos, do: data(todo)))
  end

  @doc """
  Renders a single todo.
  """
  def show(%{todo: todo}) do
    ok(data(todo))
  end

  defp data(%Todo{} = todo) do
    %{
      id: todo.id,
      name: todo.name,
      completed: todo.completed,
      tags: todo.tags |> Enum.map(&tag_data/1)
    }
  end

  defp tag_data(%{id: id, name: name}) do
    %{id: id, name: name}
  end
end
