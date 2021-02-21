import Config

case config_env() do
  :test ->
    config :tesla, adapter: Tesla.Mock

  _ ->
    config :tesla, adapter: Tesla.Adapter.Hackney
end
