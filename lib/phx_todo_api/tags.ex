defmodule PhxTodoApi.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias PhxTodoApi.Repo

  alias PhxTodoApi.Tags.Tag
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors

  def list_tags_by_user_id(user_id) do
    Repo.all(
      from t in Tag,
        where: t.user_id == ^user_id
    )
  end

  def get_tag_by_id_and_user_id(id, user_id) do
    case Repo.get_by(
           Tag,
           id: id,
           user_id: user_id
         ) do
      nil -> Errors.error_tag_not_found()
      tag -> {:ok, tag}
    end
  end

  def get_tags_by_ids_and_user_id(ids, user_id) do
    case ids do
      [] ->
        []

      _ ->
        from(t in Tag, where: t.id in ^ids and t.user_id == ^user_id)
        |> Repo.all()
    end
  end

  def list_tags do
    Repo.all(Tag)
  end

  def get_tag(id) do
    case Repo.get(Tag, id) do
      nil -> Errors.error_tag_not_found()
      tag -> {:ok, tag}
    end
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
