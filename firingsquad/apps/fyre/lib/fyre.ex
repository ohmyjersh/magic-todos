defmodule Fyre do
  use Application
  require Logger
  @base_url "http://localhost:4002/api/v1"
  @usage_timeout 20000

  @spec start(any(), any()) :: no_return()
  def start(_type, _args) do
    email = UUID.uuid4() <> "@thing.com"
    password = "c00lstuff"
    newUser = %{"user" => %{"email" => email, "password" => password, "passwordConfirmation" => password}}
    newUserBody = Poison.encode!(newUser);
    sign_up(newUserBody)
    authUser = %{"email" => email, "password" => password}
    authTokenBody = Poison.encode!(authUser);
    token = sign_in(authTokenBody)
    todo = %{"todo" => %{"description" => "does this thing work", "completed" => false}}
    todoBody = Poison.encode!(todo)
    todos = generate_todos(todoBody)
    fireOffAsync(todos, token)
    things = []
    KafkaEx.create_worker(:streaming_worker)
    for message <- KafkaEx.stream("test", 0, worker_name: :streaming_worker) do
      json = Poison.decode!(message.value)
      List.insert_at(things, -1, json)
    end
    IO.inspect things
  end

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

  def generate_todos(todo), do: Enum.reduce(0..9, [], fn _, acc ->
    [todo | acc]
  end)

  def fireOffAsync(todos, token) do
    todos
    |> Enum.map(&(Task.async(fn -> create_todo(&1, token) end)))
    |> Enum.map(&Task.await/1)
  end
end
