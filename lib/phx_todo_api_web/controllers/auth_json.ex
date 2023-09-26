defmodule PhxTodoApiWeb.AuthJSON do
  import PhxTodoApiWeb.JSONResponse, only: [ok: 1]

  def login(%{token: token}) do
    ok(%{token: token})
  end

  def register(_) do
    ok(%{message: "Please check your email to activate your account (valid for 15 minutes)"})
  end

  def activate(_) do
    ok(%{message: "Your account has been activated. Please log in to continue"})
  end

  def resend_activation(_) do
    ok(%{
      message:
        "Activation link resent to your email. Please activate your account within 15 minutes"
    })
  end

  def forget_password(_) do
    ok(%{
      message:
        "Password reset link sent to your email. Please reset your password within 15 minutes"
    })
  end

  def reset_password(_) do
    ok(%{message: "Password reset successfully. Please log in to continue"})
  end
end
