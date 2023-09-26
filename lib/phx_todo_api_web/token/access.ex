defmodule PhxTodoApiWeb.Token.Access do
  use Joken.Config

  def token_config do
    default_claims(Application.get_env(:joken, :default_claims, []))
    |> add_claim("purpose", fn -> "access" end, &(&1 == "access"))
  end
end
