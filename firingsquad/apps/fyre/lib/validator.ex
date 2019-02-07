defmodule Validator do
  use GenServer # MOVE TO BE AN AGENT TO HANDLE OWN STATE?

  def start_link(args) do
    IO.puts "Starting validator"
    GenServer.start_link __MODULE__, args, name: Validator
  end

  def init(init_arg) do
    Process.sleep(1000)
    call_all_the_things()
    {:ok, init_arg}
  end
  #kafkaobserver
  # defp start_consumer() do
  #   GenServer.cast(:kafkaobserver, {:start_consumer})
  # end
  # defp stop_consumer() do
  #   GenServer.cast(:kafkaobserver, {:stop_consumer})
  # end

  #collector
  defp get_messages() do
    GenServer.call(:collector, :get_messages)
  end
  defp get_requests() do
    GenServer.call(:collector, :get_requests)
  end
  defp get_request_execution_time() do
    request_times = GenServer.call(:collector, :get_request_times)
    IO.inspect request_times
    Time.diff(request_times.end, request_times.start)
  end
  #should set a timeout for how long the scenario should run and
  #call both functions
  #DateTime.diff(dt2, dt1)

  def call_all_the_things() do
    IO.puts "validating...."
    requests = get_requests()
    messages = get_messages()

    IO.puts "REQUESTS:"
    IO.inspect requests
    IO.puts length(requests)
    IO.puts "MESSAGES:"
    IO.inspect messages
    IO.puts length(messages)

    time = get_request_execution_time()
    IO.puts "Execution TIME"
    IO.inspect time
  end
end
