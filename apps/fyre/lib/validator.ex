defmodule Validator do
  use GenServer # MOVE TO BE AN AGENT TO HANDLE OWN STATE?

  def start_link(args) do
    IO.puts "Starting validator"
    GenServer.start_link __MODULE__, args, name: Validator
  end

  def init(args) do
    call_all_the_things(args)
    {:ok, args}
  end

  def isSameLength(current_length, max_length) do
    case current_length == max_length do
      true -> true
      false -> false
    end
  end
  def run_over_max_runtime(test_start_time, max_runtime) do
    case diff_times(test_start_time, Time.utc_now()) > max_runtime do
      true -> true
      false -> false
    end
  end

  def has_all_requests_messages(current_request_length, current_message_length, max_length) do
    isSameLength(current_request_length, max_length) && isSameLength(current_message_length, max_length)
  end

  defp checker(current_request_length, current_message_length, max_length, test_start_time, max_runtime) do
    IO.puts "checking"
    if has_all_requests_messages(current_request_length, current_message_length, max_length) do
      IO.puts "all things check out"
      IO.puts "REQUESTS:"
      IO.puts current_request_length
      IO.puts "MESSAGES:"
      IO.puts current_message_length
      true
    else
      if run_over_max_runtime(test_start_time, max_runtime) do
        IO.puts "oops ran outta time"
        false
      else
        IO.puts "gotta check again"
        checker(get_requests_length(), get_messages_length(), max_length, test_start_time, max_runtime)
      end
    end
  end

  #kafkaobserver
  # defp start_consumer() do
  #   GenServer.cast(:kafkaobserver, {:start_consumer})
  # end
  # defp stop_consumer() do
  #   GenServer.cast(:kafkaobserver, {:stop_consumer})
  # end

  #collector
  defp get_messages_length() do
    messages = GenServer.call(:collector, :get_messages)
    length(messages)
  end
  defp get_requests_length() do
    requests = GenServer.call(:collector, :get_requests)
    length(requests)
  end
  defp get_times() do GenServer.call(:collector, :get_request_times) end
  defp get_request_execution_time(start_time, end_time) do
    diff_times(start_time, end_time)
  end
  defp diff_times(start_time, end_time), do: Time.diff(end_time, start_time)

  def call_all_the_things(args) do
    IO.puts "validating...."
    request_length = get_requests_length()
    messages_length = get_messages_length()
    times = get_times();

    #run checker
    checker(request_length, messages_length, args.max_length, times.start, args.max_runtime)
    time = get_request_execution_time(times.start, Time.utc_now())
    IO.puts "Execution TIME"
    IO.inspect time
    {:ok}
  end
end
