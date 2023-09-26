defmodule PhxTodoApiWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule LoginParams do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Login parameters",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "Email", format: :email},
        password: %Schema{type: :string, description: "Password"}
      }
    })
  end

  defmodule RegisterParams do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Register parameters",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "Email", format: :email},
        password: %Schema{type: :string, description: "Password"}
      }
    })
  end

  defmodule ResetPasswordParams do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Reset password parameters",
      type: :object,
      properties: %{
        token: %Schema{type: :string, description: "JWT token"},
        password: %Schema{type: :string, description: "Password"},
        password_confirmation: %Schema{type: :string, description: "Password confirmation"}
      }
    })
  end

  defmodule TokenParam do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Token parameter",
      type: :object,
      properties: %{
        token: %Schema{type: :string, description: "JWT token"}
      }
    })
  end

  defmodule EmailParam do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Email parameter",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "email"}
      }
    })
  end

  defmodule TodoListingResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Todo listing response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "ok"},
        data: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              id: %Schema{type: :integer, description: "Todo ID"},
              name: %Schema{type: :string, description: "Todo title"},
              tags: %Schema{
                type: :array,
                items: %Schema{
                  type: :object,
                  properties: %{
                    id: %Schema{type: :integer, description: "Tag ID"},
                    name: %Schema{type: :string, description: "Tag name"}
                  }
                }
              },
              completed: %Schema{type: :boolean, description: "Todo completed"}
            }
          }
        }
      }
    })
  end

  defmodule TagListingResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Tag listing response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "ok"},
        data: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              id: %Schema{type: :integer, description: "Todo ID"},
              name: %Schema{type: :string, description: "Todo title"}
            }
          }
        }
      }
    })
  end

  defmodule TodoParams do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Todo parameters",
      type: :object,
      properties: %{
        todo: %Schema{
          type: :object,
          properties: %{
            name: %Schema{type: :string, description: "Todo title"},
            tags: %Schema{
              type: :array,
              items: %Schema{type: :integer, description: "Tag ID"}
            },
            completed: %Schema{type: :boolean, description: "Todo completed", default: false}
          }
        }
      }
    })
  end

  defmodule TagParams do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Tag parameters",
      type: :object,
      properties: %{
        tag: %Schema{
          type: :object,
          properties: %{
            name: %Schema{type: :string, description: "Tag title"}
          }
        }
      }
    })
  end

  defmodule TodoResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Todo response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "ok"},
        data: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :integer, description: "Todo ID"},
            name: %Schema{type: :string, description: "Todo title"},
            tags: %Schema{
              type: :array,
              items: %Schema{
                type: :object,
                properties: %{
                  id: %Schema{type: :integer, description: "Tag ID"},
                  name: %Schema{type: :string, description: "Tag name"}
                }
              }
            },
            completed: %Schema{type: :boolean, description: "Todo completed"}
          }
        }
      }
    })
  end

  defmodule TagResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Tag response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "ok"},
        data: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :integer, description: "Todo ID"},
            name: %Schema{type: :string, description: "Todo title"}
          }
        }
      }
    })
  end

  defmodule MessageResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Message response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "ok"},
        data: %Schema{
          type: :object,
          properties: %{
            message: %Schema{
              type: :string,
              description: "Message"
            }
          }
        }
      }
    })
  end

  defmodule TokenResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Token response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "ok"},
        data: %Schema{
          type: :object,
          properties: %{
            token: %Schema{type: :string, description: "JWT token"}
          }
        }
      }
    })
  end

  defmodule ErrorResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Error response",
      type: :object,
      properties: %{
        code: %Schema{type: :string, description: "Error code"},
        errors: %Schema{
          type: :object,
          description: "Error details"
        }
      }
    })
  end
end
