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
  def value_is_greater_than(value, greater_than), do: value > greater_than
  def run_over_max_runtime(test_start_time, max_runtime) do
    case value_is_greater_than(diff_times(test_start_time, Time.utc_now()), max_runtime) do
      true -> true
      false -> false
    end
  end

  def is_messages_greater_than_requests(message_length, request_length),
    do: value_is_greater_than(message_length, request_length)

  def has_all_requests_messages(current_request_length, current_message_length, max_length),
    do: isSameLength(current_request_length, max_length) && isSameLength(current_message_length, max_length)

  #refactor, please halp
  defp checker(current_request_length, current_message_length, max_length, test_start_time, max_runtime) do
    IO.puts "checking"
    if has_all_requests_messages(current_request_length, current_message_length, max_length) do
      IO.puts "all things check out"
      IO.puts "REQUESTS:"
      IO.puts current_request_length
      IO.puts "MESSAGES:"
      IO.puts current_message_length
      time = get_request_execution_time(test_start_time, Time.utc_now())
      IO.puts "Execution TIME"
      IO.inspect time
      true
    else
      if run_over_max_runtime(test_start_time, max_runtime) do
        IO.puts "FAILED"
        IO.puts "Execution time succeeded the maximum runtime of #{max_runtime} seconds"
        false
      else
        if is_messages_greater_than_requests(current_message_length, current_request_length) do
          IO.puts "FAILED"
          IO.puts "Recieved messages: #{current_message_length} and requests: #{current_request_length}"
          IO.puts "protip: Clear kafka topic and try again."
          false
        else
          IO.puts "gotta check again"
          checker(get_requests_length(), get_messages_length(), max_length, test_start_time, max_runtime)
        end
      end
    end
  end

  #collector
  defp get_messages_length(), do: GenServer.call(:collector, :get_messages) |> length
  defp get_requests_length(), do: GenServer.call(:collector, :get_requests) |> length
  defp get_times(), do: GenServer.call(:collector, :get_request_times)


  defp get_request_execution_time(start_time, end_time), do: diff_times(start_time, end_time)
  defp diff_times(start_time, end_time), do: Time.diff(end_time, start_time)

  def call_all_the_things(args) do
    IO.puts "validating...."
    request_length = get_requests_length()
    messages_length = get_messages_length()
    times = get_times();

    #possibly do a check to see if app is still sending requests, if so do not start checker
    #run checker
    checker(request_length, messages_length, args.max_length, times.start, args.max_runtime)
    {:ok}
  end
end
