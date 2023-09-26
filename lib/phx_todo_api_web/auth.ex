defmodule PhxTodoApiWeb.Auth do
  alias PhxTodoApiWeb.Token.Access
  alias PhxTodoApiWeb.Token.Activation
  alias PhxTodoApiWeb.Token.PasswordReset
  alias PhxTodoApi.Users
  alias PhxTodoApi.Users.User
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors

  def access_token!(%User{} = user), do: Access.generate_and_sign!(%{"user_id" => user.id})

  def activation_token!(%User{} = user),
    do: Activation.generate_and_sign!(%{"user_id" => user.id})

  def password_reset_token!(%User{} = user),
    do: PasswordReset.generate_and_sign!(%{"user_id" => user.id})

  def validate_access_token(token) do
    case Access.verify_and_validate(token) do
      {:ok, %{"user_id" => user_id} = _claims} ->
        Users.get_user_by_id(user_id)

      _ ->
        Errors.error_invalid_token()
    end
  end

  def validate_activation_token(token) do
    case Activation.verify_and_validate(token) do
      {:ok, %{"user_id" => user_id} = _claims} ->
        Users.get_user_by_id(user_id)

      _ ->
        Errors.error_invalid_token()
    end
  end

  def validate_password_reset_token(token) do
    case PasswordReset.verify_and_validate(token) do
      {:ok, %{"user_id" => user_id} = _claims} ->
        with {:ok, user} <- Users.get_user_by_id(user_id),
             {:ok, %{"iat" => iat} = _claims} <- peek_claims(token) do
          case NaiveDateTime.compare(
                 user.updated_at,
                 iat |> DateTime.from_unix!() |> DateTime.to_naive()
               ) do
            :lt ->
              {:ok, user}

            _ ->
              Errors.error_invalid_token()
          end
        end

      _ ->
        Errors.error_invalid_token()
    end
  end

  def peek_claims(token) do
    case Joken.peek_claims(token) do
      {:error, _} -> Errors.error_invalid_token()
      res -> res
    end
  end
end
