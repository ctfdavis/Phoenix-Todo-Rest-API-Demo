defmodule PhxTodoApi.Errors do
  @moduledoc """
    This module generates two macros for each error atom defined in @errors
    1. a macro of the atom name which returns the atom itself
    2. a macro of the atom name prefixed by "error_" which returns a pair tuple of :error and the atom itself
    3. a macro of the atom name prefixed by "json_" which returns a string of the atom name with the ".json" suffix
    e.g. for :todo_not_found, we generate:
    defmacro todo_not_found, do: :todo_not_found
    defmacro error_todo_not_found, do: {:error, :todo_not_found}
  """

  @errors [
    :todo_not_found,
    :tag_not_found,
    :user_not_found,
    :user_not_activated,
    :user_already_activated,
    :invalid_token,
    :too_many_requests
  ]

  for error <- @errors do
    defmacro unquote(error)(), do: unquote(error)
    defmacro unquote(:"error_#{error}")(), do: {:error, unquote(error)}
    defmacro unquote(:"json_#{error}")(), do: unquote("#{error}.json")
  end
end
