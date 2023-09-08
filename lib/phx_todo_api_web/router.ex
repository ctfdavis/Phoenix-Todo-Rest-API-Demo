defmodule PhxTodoApiWeb.Router do
  use PhxTodoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PhxTodoApiWeb.Auth
  end

  scope "/api", PhxTodoApiWeb do
    pipe_through :api

    scope "" do
      pipe_through :auth
      resources "/todos", TodoController, except: [:new, :edit]
    end

    scope "/auth" do
      post "/login", AuthController, :login
      post "/register", AuthController, :register
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phx_todo_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PhxTodoApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
