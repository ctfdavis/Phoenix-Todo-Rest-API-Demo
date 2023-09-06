defmodule PhxTodoApiWeb.Token do
  use Joken.Config

  def token_config, do: default_claims(Application.get_env(:joken, :default_claims, []))
end
