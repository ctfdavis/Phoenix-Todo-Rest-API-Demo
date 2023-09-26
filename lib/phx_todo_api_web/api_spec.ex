defmodule PhxTodoApiWeb.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi, Paths, Server, Components, SecurityScheme}
  alias PhxTodoApiWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Phx Todo Api",
        version: "1.0"
      },
      components: %Components{
        securitySchemes: %{"authorization" => %SecurityScheme{type: "http", scheme: "bearer"}}
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router)
    }
    # Discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end
end
