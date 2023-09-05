# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhxTodoApi.Repo.insert!(%PhxTodoApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

PhxTodoApi.Repo.insert!(%PhxTodoApi.Users.User{
  email: "testuser@gmail.com",
  password_hash: Argon2.hash_pwd_salt("password")
})

PhxTodoApi.Repo.insert!(%PhxTodoApi.Users.User{
  email: "testuser2@gmail.com",
  password_hash: Argon2.hash_pwd_salt("password2")
})
