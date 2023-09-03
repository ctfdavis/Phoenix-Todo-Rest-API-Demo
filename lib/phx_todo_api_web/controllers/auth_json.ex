defmodule PhxTodoApiWeb.AuthJSON do
  def login(%{token: token}) do
    %{data: %{token: token}}
  end
end
