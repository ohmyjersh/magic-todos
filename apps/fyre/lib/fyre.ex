defmodule Fyre do
  use GenServer # MOVE TO BE AN AGENT TO HANDLE OWN STATE?
  @base_url "http://localhost:4002/api/v1"

  def start_link(args) do
    GenServer.start_link __MODULE__, args, name: Fyre
  end

  def init(args) do
    start(args)
    {:ok, args}
  end

  def on_request_success(todo) do
    GenServer.cast(:collector, {:handle_request, todo})
  end

  def start(args) do
    email = UUID.uuid4() <> "@thing.com"
    password = "c00lstuff"
    newUser = %{"user" => %{"email" => email, "password" => password, "passwordConfirmation" => password}}
    newUserBody = Poison.encode!(newUser);
    sign_up(newUserBody)
    authUser = %{"email" => email, "password" => password}
    authTokenBody = Poison.encode!(authUser);
    token = sign_in(authTokenBody)
    todos = generate_todos(args.max_length)
    GenServer.cast(:collector, {:request_start_time})
    Process.sleep(5000)
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
    HTTPoison.post(@base_url <> "/todos/delayed", params, headers(token)) #remove ! and actually look for success and push
  end

  # defp update_todo(id, params, token) do
  #   HTTPoison.put!(@base_url <> "/todos" <> id, params, headers(token))
  # end

  defp generate_todos(n), do: Enum.reduce(1..n, [], fn _, acc ->
    todo = %{"todo" => %{"description" => UUID.uuid4(), "completed" => false}} |> Poison.encode!
    [todo | acc]
  end)

  defp fireOffAsync(todos, token) do
    todos
    |> Enum.map(&(Task.async(fn -> case create_todo(&1, token) do
      {:ok, _} -> on_request_success(&1)
      end
    end)))
    |> Enum.chunk_every(5)
    |> Enum.each(fn item ->
      Enum.each(item, fn x -> Task.await(x) end)
    end)
  end
end
