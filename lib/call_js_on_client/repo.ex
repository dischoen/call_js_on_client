defmodule CallJSonClient.Repo do
  use Ecto.Repo,
    otp_app: :call_js_on_client,
    adapter: Ecto.Adapters.Postgres
end
