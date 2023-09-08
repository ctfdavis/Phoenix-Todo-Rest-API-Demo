defmodule PhxTodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias PhxTodoApi.Repo

  alias PhxTodoApi.Todos.Todo

  def error_todo_not_found do
    {:error, :todo_not_found}
  end

  def list_todos_by_user_id(user_id) do
    Repo.all(from t in Todo, where: t.user_id == ^user_id)
  end

  def get_todo_by_id_and_user_id(id, user_id) do
    case Repo.get_by(Todo, id: id, user_id: user_id) do
      nil -> error_todo_not_found()
      todo -> {:ok, todo}
    end
  end

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo)
  end

  @doc """
  Gets a single todo.

  Returns {:error, :todo_not_found} if the Todo does not exist.

  ## Examples

      iex> get_todo(123)
      {:ok, %Todo{}}

      iex> get_todo!(456)
      {:error, :todo_not_found}

  """
  def get_todo(id) do
    case Repo.get(Todo, id) do
      nil -> {:error, :todo_not_found}
      todo -> {:ok, todo}
    end
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
