# Phoenix REST API Demo

## Primary packages

- Phoenix: web server infrastructure
- Ecto: ORM
- Joken: token management
- Argon2: cryptography
- Swoosh: email client
- Premailex: email formatting
- Open API Spex: open api specification

## Features

- Authentication
  - Register
  - Account activation via email
    - HEEX page for activation
  - Resend activation email
  - Sign in
  - Forget password
    - HEEX page with form
- Todos
  - Listing (optionally filter by tags)
  - CRUD
- Tags
  - Listing
  - CRUD
- Swagger

## Getting started

To start your Phoenix server:

- Create a Postgresql database instance following the settings in `config/dev.exs`
- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. The homepage contains links to the swagger ui and local mailbox for demo usages.
