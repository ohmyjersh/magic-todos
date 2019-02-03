defmodule Validator do
  @moduledoc """
  Main consumer implementation
  This implementsa KafkaEx.GenConsumer.  The only function we need to
  implement is `handle_message_set/2`.
  """

  # this is required
  use KafkaEx.GenConsumer

  # this is not required - I have aliased it for convenience
  alias KafkaEx.Protocol.Fetch.Message

  # this is not generally required, but is required here so that we can
  # log messages
  require Logger

  @doc """
  Main message handling callback function
  Note that we receive multiple messages each time.  Because of the way that
  Kafka works, each request to the broker can provide us with multiple
  messages.
  We return `{:async_commit, consumer_state}` - we do not modify the state
  and we want offsets to be committed asynchronously.  Async commits
  balance safety and performance.
  """
  @messages []
  def start() do

  end
  @spec handle_message_set([Message.t], term) :: {:async_commit, term}
  def handle_message_set(messages, consumer_state) do
    # just loop through each message and print it out
    for  message = %Message{} <- messages do
      IO.inspect message
      #todo = Poison.decode!(message.value)
      #TodoService.Todo.add(todo["user_id"], todo["description"], todo["completed"])
      #Logger.debug(fn -> "GOT: #{inspect message}" end)
    end
    {:async_commit, consumer_state}
  end
end
