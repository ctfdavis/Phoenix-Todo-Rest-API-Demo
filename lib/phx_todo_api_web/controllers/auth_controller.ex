defmodule PhxTodoApiWeb.AuthController do
  use PhxTodoApiWeb, :controller
  alias PhxTodoApi.Mailer
  alias PhxTodoApi.Users
  alias PhxTodoApi.Users.User
  alias PhxTodoApiWeb.Emails.UserEmail
  alias PhxTodoApiWeb.Auth
  require PhxTodoApi.Errors
  alias PhxTodoApi.Errors
  use OpenApiSpex.ControllerSpecs
  alias PhxTodoApiWeb.Schemas

  tags ["Authentication"]

  action_fallback PhxTodoApiWeb.FallbackController

  operation :login,
    summary: "Login",
    request_body: {
      "Login params",
      "application/json",
      Schemas.LoginParams
    },
    responses: [
      ok: {"Login response", "application/json", Schemas.TokenResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      unprocessable_entity: {
        "Unprocessable entity",
        "application/json",
        Schemas.ErrorResponse
      }
    ]

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Users.get_user_by_email(email) do
      if Argon2.verify_pass(password, user.password_hash) do
        if user.is_activated do
          token = Auth.access_token!(user)

          conn
          |> put_status(:ok)
          |> render(:login, token: token)
        else
          Errors.error_user_not_activated()
        end
      else
        Errors.error_user_not_found()
      end
    end
  end

  operation :register,
    summary: "Register",
    request_body: {
      "Register params",
      "application/json",
      Schemas.RegisterParams
    },
    responses: [
      ok: {"Register response", "application/json", Schemas.MessageResponse},
      unprocessable_entity: {
        "Unprocessable entity",
        "application/json",
        Schemas.ErrorResponse
      }
    ]

  def register(conn, user_params) do
    with {:ok, %User{} = user} <-
           Users.create_user(user_params),
         {:ok, _} <- Users.update_last_activation_sent_at(user) do
      UserEmail.activation_email(user.email, Auth.activation_token!(user))
      |> Mailer.deliver()

      conn |> put_status(:ok) |> render(:register)
    end
  end

  operation :activate,
    summary: "Activate",
    request_body: {
      "token",
      "application/json",
      Schemas.TokenParam
    },
    responses: [
      ok: {"Activate response", "application/json", Schemas.MessageResponse},
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def activate(conn, %{"token" => token}) do
    with {:ok, user} <- Auth.validate_activation_token(token),
         {:ok, _} <- Users.activate_user(user) do
      conn |> put_status(:ok) |> render(:activate)
    end
  end

  operation :resend_activation,
    summary: "Resend activation",
    request_body: {
      "Email",
      "application/json",
      Schemas.EmailParam
    },
    responses: [
      ok: {
        "Resend activation response",
        "application/json",
        Schemas.MessageResponse
      },
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def resend_activation(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- Users.get_user_by_email(email),
         user <- Users.load_last_activation_sent_at(user) do
      case {user.is_activated,
            user.last_activation_sent_at == nil ||
              NaiveDateTime.diff(NaiveDateTime.utc_now(), user.last_activation_sent_at) <
                resend_activation_time_threshold()} do
        {true, _} ->
          Errors.error_user_already_activated()

        {_, true} ->
          Errors.error_too_many_requests()

        _ ->
          UserEmail.activation_email(user.email, Auth.activation_token!(user))
          |> Mailer.deliver()

          Users.update_last_activation_sent_at(user)

          conn |> put_status(:ok) |> render(:resend_activation)
      end
    end
  end

  operation :forget_password,
    summary: "Forget password",
    request_body: {
      "Email",
      "application/json",
      Schemas.EmailParam
    },
    responses: [
      ok: {
        "Forget password response",
        "application/json",
        Schemas.MessageResponse
      },
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse}
    ]

  def forget_password(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- Users.get_user_by_email(email),
         user <- Users.load_last_password_reset_sent_at(user) do
      if user.last_password_reset_sent_at == nil ||
           NaiveDateTime.diff(NaiveDateTime.utc_now(), user.last_password_reset_sent_at) >
             resend_password_reset_time_threshold() do
        UserEmail.password_reset_email(user.email, Auth.password_reset_token!(user))
        |> Mailer.deliver()

        Users.update_last_password_reset_sent_at(user)

        conn |> put_status(:ok) |> render(:forget_password)
      else
        Errors.error_too_many_requests()
      end
    end
  end

  operation :reset_password,
    summary: "Reset password",
    request_body: {
      "Reset password params",
      "application/json",
      Schemas.ResetPasswordParams
    },
    responses: [
      ok: {
        "Reset password response",
        "application/json",
        Schemas.MessageResponse
      },
      unauthorized: {"Unauthorized", "application/json", Schemas.ErrorResponse},
      unprocessable_entity: {
        "Unprocessable entity",
        "application/json",
        Schemas.ErrorResponse
      }
    ]

  def reset_password(
        conn,
        %{
          "token" => token
        } = reset_params
      ) do
    with {:ok, user} <- validate_password_reset_token(token),
         {:ok, _} <-
           Users.update_user(user, reset_params) do
      conn |> put_status(:ok) |> render(:reset_password)
    end
  end

  def validate_password_reset_token(token) do
    with {:ok, user} <- Auth.validate_password_reset_token(token),
         {:ok, %{"iat" => iat} = _claims} <- Auth.peek_claims(token) do
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
  end

  defp resend_activation_time_threshold, do: get_threshold(:activation)
  defp resend_password_reset_time_threshold, do: get_threshold(:password_reset)

  defp get_threshold(type) do
    Application.get_env(:phx_todo_api, :resend_email_time_threshold_in_s)
    |> Keyword.get(type, 60)
  end
end
