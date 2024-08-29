defmodule CallJSonClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CallJSonClientWeb.Telemetry,
      CallJSonClient.Repo,
      {DNSCluster, query: Application.get_env(:call_js_on_client, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CallJSonClient.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CallJSonClient.Finch},
      # Start a worker by calling: CallJSonClient.Worker.start_link(arg)
      # {CallJSonClient.Worker, arg},
      # Start to serve requests, typically the last entry
      CallJSonClientWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CallJSonClient.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CallJSonClientWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
