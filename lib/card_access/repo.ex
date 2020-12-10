defmodule CardAccess.Repo do
  use Ecto.Repo,
    otp_app: :card_access,
    adapter: Ecto.Adapters.Postgres
end
