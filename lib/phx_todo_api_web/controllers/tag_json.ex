defmodule PhxTodoApiWeb.TagJSON do
  import PhxTodoApiWeb.JSONResponse, only: [ok: 1]
  alias PhxTodoApi.Tags.Tag

  @doc """
  Renders a list of tags.
  """
  def index(%{tags: tags}) do
    ok(for(tag <- tags, do: data(tag)))
  end

  @doc """
  Renders a single tag.
  """
  def show(%{tag: tag}) do
    ok(data(tag))
  end

  defp data(%Tag{} = tag) do
    %{
      id: tag.id,
      name: tag.name
    }
  end
end
