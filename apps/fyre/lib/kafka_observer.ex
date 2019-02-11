defmodule KafkaObserver do
  use GenServer # MOVE TO BE AN AGENT TO HANDLE OWN STATE?

  def start_link(args) do
    GenServer.start_link __MODULE__, args, name: :kafkaobserver
  end

  def init(state) do
    Task.async(fn -> async_message_handler() end)
    {:ok, state}
  end

  defp async_message_handler() do
    KafkaEx.create_worker(:streaming_worker)
    for message <- KafkaEx.stream("test", 0, worker_name: :streaming_worker) do
      json = Poison.decode!(message.value)
      GenServer.cast(:collector, {:handle_messages, json})
    end
  end
end
