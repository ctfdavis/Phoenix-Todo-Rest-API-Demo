defmodule PhxTodoApiWeb.Emails.UserEmail do
  import Swoosh.Email

  defp render_with_layout(email, heex) do
    html_string =
      render_component(PhxTodoApiWeb.EmailHTML.layout(%{message: heex}))

    email
    |> html_body(Premailex.to_inline_css(html_string))
    |> text_body(Premailex.to_text(html_string))
  end

  defp render_component(heex) do
    heex |> Phoenix.HTML.Safe.to_iodata() |> IO.chardata_to_string()
  end

  def activation_email(email, token) do
    new()
    |> from("no-reply@phx_todo_api.com")
    |> to(email)
    |> subject("Activate Your Account")
    |> render_with_layout(PhxTodoApiWeb.EmailHTML.activation_email(%{email: email, token: token}))
  end

  def password_reset_email(email, token) do
    new()
    |> from("no-reply@phx_todo_api.com")
    |> to(email)
    |> subject("Reset Your Password")
    |> render_with_layout(
      PhxTodoApiWeb.EmailHTML.password_reset_email(%{
        email: email,
        token: token
      })
    )
  end
end
