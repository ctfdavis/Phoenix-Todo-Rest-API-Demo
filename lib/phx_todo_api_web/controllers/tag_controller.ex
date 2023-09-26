defmodule PhxTodoApiWeb.TagController do
  use PhxTodoApiWeb, :controller

  alias PhxTodoApi.Tags
  alias PhxTodoApi.Tags.Tag
  use OpenApiSpex.ControllerSpecs
  alias PhxTodoApiWeb.Schemas

  tags ["Tags"]
  security [%{"authorization" => []}]

  action_fallback PhxTodoApiWeb.FallbackController

  operation :index,
    summary: "List tags of signed in user",
    responses: [
      ok: {"Tag listing response", "application/json", Schemas.TagListingResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def index(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        _params
      ) do
    tags = Tags.list_tags_by_user_id(user_id)
    render(conn, :index, tags: tags)
  end

  operation :create,
    summary: "Create a tag for signed in user",
    request_body: {
      "Create tag params",
      "application/json",
      Schemas.TagParams
    },
    responses: [
      created: {"Tag response", "application/json", Schemas.TagResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def create(%Plug.Conn{assigns: %{user_id: user_id}} = conn, %{"tag" => tag_params}) do
    with {:ok, %Tag{} = tag} <- Tags.create_tag(Map.put(tag_params, "user_id", user_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tags/#{tag}")
      |> render(:show, tag: tag)
    end
  end

  operation :show,
    summary: "Get a tag detail by id owned by signed in user",
    parameters: [
      id: [in: :path, description: "Tag id", required: true, type: :integer, example: 1]
    ],
    responses: [
      ok: {"Tag response", "application/json", Schemas.TagResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      not_found: {"Tag not found", "application/json", Schemas.ErrorResponse}
    ]

  def show(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"id" => id}
      ) do
    with {:ok, %Tag{} = tag} <- Tags.get_tag_by_id_and_user_id(id, user_id) do
      render(conn, :show, tag: tag)
    end
  end

  operation :update,
    summary: "Update a tag by id owned by signed in user",
    parameters: [
      id: [in: :path, description: "Tag id", required: true, type: :integer, example: 1]
    ],
    request_body: {
      "Update tag params",
      "application/json",
      Schemas.TagParams
    },
    responses: [
      ok: {"Tag response", "application/json", Schemas.TagResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      not_found: {"Todo not found", "application/json", Schemas.ErrorResponse}
    ]

  def update(
        %Plug.Conn{assigns: %{user_id: user_id}} = conn,
        %{"id" => id, "tag" => tag_params}
      ) do
    with {:ok, %Tag{} = tag} <- Tags.get_tag_by_id_and_user_id(id, user_id),
         {:ok, %Tag{} = tag} <- Tags.update_tag(tag, tag_params) do
      render(conn, :show, tag: tag)
    end
  end

  operation :delete,
    summary: "Delete a tag by id owned by signed in user",
    parameters: [
      id: [in: :path, description: "Tag id", required: true, type: :integer, example: 1]
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
    with {:ok, %Tag{} = tag} <- Tags.get_tag_by_id_and_user_id(id, user_id),
         {:ok, %Tag{}} <- Tags.delete_tag(tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
