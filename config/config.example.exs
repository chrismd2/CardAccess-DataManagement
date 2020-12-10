import Config

config :card_access, CardAccess.Repo,
  database: "card_access_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  template: "template0"

config :card_access, ecto_repos: [CardAccess.Repo]

config :phoenix, :json_library, Jason
