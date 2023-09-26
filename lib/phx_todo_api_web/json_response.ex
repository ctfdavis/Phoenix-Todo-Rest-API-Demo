defmodule PhxTodoApiWeb.JSONResponse do
  def ok(data) do
    %{code: "ok", data: data}
  end

  def err(error_code, errors) when is_atom(error_code) do
    err(to_string(error_code), errors)
  end

  def err(error_code, errors) when is_binary(error_code) do
    %{code: error_code, errors: errors}
  end
end
