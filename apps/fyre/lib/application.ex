defmodule Fyre.Application do
  use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # Define workers and child supervisors to be supervised
    max_length = 20 # 20 requests
    max_runtime = 100 # 100 seconds
    children = [
      {Collector,%{:max_length => max_length}} ,
      {KafkaObserver, %{:max_length => max_length}},
      {Fyre, %{:max_length => max_length}},
      {Validator, %{:max_length => max_length, :max_runtime => max_runtime}}
    ]
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fyre.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
