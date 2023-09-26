# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phx_todo_api,
  ecto_repos: [PhxTodoApi.Repo]

# Configures the endpoint
config :phx_todo_api, PhxTodoApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: PhxTodoApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PhxTodoApi.PubSub,
  live_view: [signing_salt: "76qxZkPv"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :phx_todo_api, PhxTodoApi.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :joken,
  default_signer: "not_a_secret",
  default_claims: [
    # 12 hours
    default_exp: 60 * 60 * 12,
    iss: "phx_todo_api",
    aud: "phx_todo_api"
  ],
  activation_default_claims: [
    # 15 minutes
    default_exp: 60 * 15
  ],
  password_reset_default_claims: [
    # 15 minutes
    default_exp: 60 * 15
  ]

config :phx_todo_api, :resend_email_time_threshold_in_s,
  activation: 60,
  password_reset: 60

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
