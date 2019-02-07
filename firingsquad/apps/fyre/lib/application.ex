defmodule Fyre.Application do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # Define workers and child supervisors to be supervised
    children = [
      {Collector, {}},
      {KafkaObserver, {}},
      {Fyre, {}},
      {Validator, {}}
    ]
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fyre.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
