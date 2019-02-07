defmodule Fyre do
  use GenServer # MOVE TO BE AN AGENT TO HANDLE OWN STATE?
  @base_url "http://localhost:4002/api/v1"

  def start_link(_args) do
    GenServer.start_link __MODULE__, %{}, name: Fyre
  end

  def init(init_arg) do
    start()
    {:ok, init_arg}
  end

  def start() do
    email = UUID.uuid4() <> "@thing.com"
    password = "c00lstuff"
    newUser = %{"user" => %{"email" => email, "password" => password, "passwordConfirmation" => password}}
    newUserBody = Poison.encode!(newUser);
    sign_up(newUserBody)
    authUser = %{"email" => email, "password" => password}
    authTokenBody = Poison.encode!(authUser);
    token = sign_in(authTokenBody)
    todos = generate_todos()
    GenServer.cast(:collector, {:handle_requests, todos})
    GenServer.cast(:collector, {:request_start_time})
    Process.sleep(10000)
    fireOffAsync(todos, token)
    GenServer.cast(:collector, {:request_end_time})
  end

  #helpers
  defp headers(token) do
    [{"Authorization", "Bearer #{token}"}, {"Content-Type", "application/json"}]
  end
  defp headers() do
    [{"Content-type", "application/json"}]
  end
  defp sign_up(params) do
   response = HTTPoison.post!(@base_url <> "/sign_up", params, headers())
   token = Poison.decode!(response.body)
   get_in((token), ["jwt"])
  end
  defp sign_in(params) do
    response = HTTPoison.post!(@base_url <> "/sign_in", params, headers())
    token = Poison.decode!(response.body)
    get_in((token), ["jwt"])
  end
  defp create_todo(params, token) do
    HTTPoison.post!(@base_url <> "/todos/delayed", params, headers(token))
  end

  defp update_todo(id, params, token) do
    HTTPoison.put!(@base_url <> "/todos" <> id, params, headers(token))
  end

  defp generate_todos(), do: Enum.reduce(0..9, [], fn _, acc ->
    todo = %{"todo" => %{"description" => UUID.uuid4(), "completed" => false}} |> Poison.encode!
    [todo | acc]
  end)

  defp fireOffAsync(todos, token) do
    todos
    |> Enum.map(&(Task.async(fn -> create_todo(&1, token) end)))
    |> Enum.map(&Task.await/1)
  end
end
