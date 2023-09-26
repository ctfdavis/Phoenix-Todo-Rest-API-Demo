defmodule PhxTodoApiWeb.Token.PasswordReset do
  use Joken.Config

  def token_config do
    default_claims(
      Keyword.merge(
        Application.get_env(:joken, :default_claims, []),
        Application.get_env(:joken, :password_reset_default_claims, [])
      )
    )
    |> add_claim("purpose", fn -> "password_reset" end, &(&1 == "password_reset"))
  end
end
