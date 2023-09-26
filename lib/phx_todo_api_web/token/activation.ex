defmodule PhxTodoApiWeb.Token.Activation do
  use Joken.Config

  def token_config do
    default_claims(
      Keyword.merge(
        Application.get_env(:joken, :default_claims, []),
        Application.get_env(:joken, :activation_default_claims, [])
      )
    )
    |> add_claim("purpose", fn -> "activation" end, &(&1 == "activation"))
  end
end
