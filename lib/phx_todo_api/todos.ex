defmodule PhxTodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias PhxTodoApi.Repo

  alias PhxTodoApi.Tags
  alias PhxTodoApi.Todos.Todo
  alias PhxTodoApi.Todos.Tags, as: TodoTags
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors

  def list_todos_by_user_id_and_tag_ids(user_id, tag_ids) do
    todo = Todo |> preload(:tags)

    query =
      if tag_ids == [] do
        from t in todo,
          where: t.user_id == ^user_id
      else
        from t in todo,
          where:
            t.user_id == ^user_id and
              t.id in subquery(
                from tt in TodoTags, where: tt.tag_id in ^tag_ids, select: tt.todo_id
              )
      end

    Repo.all(query)
  end

  def get_todo_by_id_and_user_id(id, user_id) do
    case Repo.get_by(Todo, id: id, user_id: user_id) do
      nil -> Errors.error_todo_not_found()
      todo -> {:ok, todo |> Repo.preload(:tags)}
    end
  end

  def list_todos do
    Repo.all(Todo |> preload(:tags))
  end

  def get_todo(id) do
    case Repo.get(Todo, id) do
      nil -> Errors.error_todo_not_found()
      todo -> {:ok, todo |> Repo.preload(:tags)}
    end
  end

  def create_todo(%{"user_id" => user_id} = attrs \\ %{}) do
    {tags, attrs} = Map.pop(attrs, "tags", [])

    changeset =
      %Todo{}
      |> Todo.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:tags, Tags.get_tags_by_ids_and_user_id(tags, user_id))

    with {:ok, todo} <- Repo.insert(changeset) do
      {:ok, todo |> Repo.preload(:tags)}
    end
  end

  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
  end

  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
