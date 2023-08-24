import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :phx_todo_api, PhxTodoApi.Repo,
  username: "phx_todo_api",
  password: "phx_todo_api",
  hostname: "localhost",
  database: "phx_todo_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  port: 2000,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx_todo_api, PhxTodoApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RJqMztOiejj58nehcPRWxvrAFSKOd2WbMdxYcbzGABR/lE0aNhOpo87jj3AdFG17",
  server: false

# In test we don't send emails.
config :phx_todo_api, PhxTodoApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
