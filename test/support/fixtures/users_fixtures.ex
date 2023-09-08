defmodule PhxTodoApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxTodoApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test_email@example.com",
        password: "test_password_123"
      })
      |> PhxTodoApi.Users.create_user()

    user
  end
end
