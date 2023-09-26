defmodule PhxTodoApiWeb.ErrorJSON do
  import PhxTodoApiWeb.JSONResponse, only: [err: 2]
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors

  def render(json, _assigns) when json == Errors.json_tag_not_found() do
    err(:tag_not_found, %{tag: "not found"})
  end

  def render(json, _assigns) when json == Errors.json_todo_not_found() do
    err(:todo_not_found, %{todo: "not found"})
  end

  def render(json, _assigns) when json == Errors.json_user_not_found() do
    err(:user_not_found, %{user: "not found"})
  end

  def render(json, _assigns) when json == Errors.json_user_not_activated() do
    err(:user_not_activated, %{user: "not activated"})
  end

  def render(json, _assigns) when json == Errors.json_user_already_activated() do
    err(:user_already_activated, %{user: "already activated"})
  end

  def render(json, _assigns) when json == Errors.json_invalid_token() do
    err(:invalid_token, %{token: "invalid"})
  end

  def render(json, _assigns) when json == Errors.json_too_many_requests() do
    err(:too_many_requests, %{requests: "too many requests"})
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    err(:generic_error, %{
      detail: Phoenix.Controller.status_message_from_template(template)
    })
  end
end
