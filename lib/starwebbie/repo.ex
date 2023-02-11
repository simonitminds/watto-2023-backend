defmodule Starwebbie.Repo do
  use Ecto.Repo,
    otp_app: :starwebbie,
    adapter: Ecto.Adapters.Postgres
end
