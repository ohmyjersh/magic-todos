defmodule Collector do
  use GenServer

  defmodule State do
    defstruct messages: [], requests: [], request_start_time: nil, request_end_time: nil, requests_processing: false
  end

  def start_link(_args) do
    GenServer.start_link __MODULE__, %State{}, name: :collector
  end

  def init(state) do
    {:ok, state}
  end
  #gets
  def handle_call(:get_messages, _from, state) do
    {:reply, state.messages, state}
  end
  def handle_call(:get_requests, _from, state) do
    {:reply, state.requests, state}
  end

  def handle_call(:get_request_times, _from, state) do
    {:reply, %{:start => state.request_start_time, :end => state.request_end_time}, state}
  end
  def handle_call(:is_requests_processing, _from, state) do
    {:reply, state.requests_processing, state}
  end

  #puts
  def handle_cast({:handle_messages, message}, state) do
    messages = state.messages
    newMessages = messages ++ [message]
    newState = Map.put(state, :messages, newMessages)
    {:noreply, newState }
  end
  def handle_cast({:request_start_time}, state) do
    newState = Map.put(state, :request_start_time, Time.utc_now())
    {:noreply, newState }
  end
  def handle_cast({:request_end_time}, state) do
    newState = Map.put(state, :request_end_time, Time.utc_now())
    {:noreply, newState }
  end
  def handle_cast({:handle_requests, request}, state) do
    requests = state.requests
    cleanedUp = Enum.map(request, fn x -> get_todo(x) end)
    newRequests = requests ++ cleanedUp
    newState = Map.put(state, :requests, newRequests)
    {:noreply, newState }
  end
  def handle_cast({:requests_processing, processing}, state) do
    newState = Map.put(state, :requests_processing, processing)
    {:noreply, newState }
  end

  #helpers
  def get_todo(todo) do
    decoded_todo = Poison.decode!(todo)
    Map.get(decoded_todo, "todo")
  end
end
