defmodule WxElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def restart do
    :ok = Supervisor.stop(WxElixir.Supervisor)
    start(nil, nil)
  end

  @impl true
  def start(_type, _args) do
    # Order matters here - the gui is dependent on the agent being up
    children = [
      {WxElixir.Task.Store, [write_to_disk: true]},
      WxElixir.Server
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WxElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
