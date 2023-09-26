defmodule PhxTodoApiWeb.Router do
  use PhxTodoApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhxTodoApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug OpenApiSpex.Plug.PutApiSpec, module: PhxTodoApiWeb.ApiSpec
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PhxTodoApiWeb.Auth.AccessValidator
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api", PhxTodoApiWeb do
    pipe_through :api

    scope "/" do
      pipe_through :auth
      resources "/todos", TodoController, except: [:new, :edit]
      resources "/tags", TagController, except: [:new, :edit]
    end

    scope "/auth" do
      post "/login", AuthController, :login
      post "/register", AuthController, :register
      post "/activate", AuthController, :activate
      post "/resend-activation", AuthController, :resend_activation
      post "/forget-password", AuthController, :forget_password
      patch "/reset-password", AuthController, :reset_password
    end
  end

  scope "/", PhxTodoApiWeb do
    pipe_through :browser
    get "/", PageController, :index
    get "/password-reset", PageController, :password_reset
    get "/activate", PageController, :activate
  end

  scope "/" do
    pipe_through :browser
    get "/swagger-ui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhxTodoApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
