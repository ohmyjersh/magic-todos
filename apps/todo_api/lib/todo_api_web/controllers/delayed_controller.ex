defmodule TodoApiWeb.DelayedController do
  use TodoApiWeb, :controller

  alias TodoApi.Accounts
  alias TodoApi.Accounts.User
  alias TodoApi.Todos
  alias TodoApi.Todos.Todo
  alias TodoApi.Guardian
  action_fallback TodoApiWeb.FallbackController

  def index(conn, %{"todo" => todo_params}) do
      case Guardian.Plug.current_resource(conn) do
        nil -> {:error}
        {:error} -> {:error, :not_found}
        user ->
          new_todo = mapTodo(todo_params, user.id)
          case KafkaEx.produce("test", 0, Poison.encode!(new_todo)) do
          nil -> {:error}
          {:error,_} -> IO.inspect :error
          _ ->
            conn
              |> put_status(:created)
              |> text("")
          end
      end
  end
  defp mapTodo(todo, user_id) do
    baseId = Map.get(todo, "baseTodoId")
    cond do
      baseId -> case Todos.get_todo!(baseId, user_id) do
          baseTodo -> mergeTodo(baseTodo, todo) |> addUserId(user_id)
      end
      true -> addUserId(todo, user_id)
    end
  end

  defp mergeTodo(baseTodo, todo), do: Map.merge(%{"description" => baseTodo.description, "completed" => baseTodo.completed}, todo)

  defp addUserId(todo, user_id), do:  Map.put(todo,"user_id", user_id)
end
