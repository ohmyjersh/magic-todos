defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Todos
  alias TodoApi.Todos.Todo
  alias TodoApi.Guardian

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      nil -> {:error}
      {:error} -> {:error, :not_found}
      user ->
        todos = Todos.list_todos(user.id)
        render(conn, "index.json", todos: todos)
      end
  end

  def create(conn, %{"todo" => todo_params}) do
    case Guardian.Plug.current_resource(conn) do
      nil -> {:error}
      {:error} -> {:error, :not_found}
      user ->
        new_todo = mapTodo(todo_params, user.id)
        IO.inspect new_todo
        with {:ok, %Todo{} = todo} <- Todos.create_todo(new_todo) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
          |> render("show.json", todo: todo)
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

  def show(conn, %{"id" => id}) do
    case Guardian.Plug.current_resource(conn) do
      nil -> {:error}
      {:error} -> {:error, :not_found}
      user ->
        todo = Todos.get_todo!(id, user.id)
        render(conn, "show.json", todo: todo)
      end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    user = Guardian.Plug.current_resource(conn)
    todo = Todos.get_todo!(id, user.id)
    cond do
      todo.user_id == user.id ->
        with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
        render(conn, "show.json", todo: todo)
      end
      true -> {:error, :not_found}
    end
  end

  def delete(conn, %{"id" => id}) do
    case Guardian.Plug.current_resource(conn) do
      nil -> {:error}
      {:error} -> {:error, :not_found}
      user ->
        todo = Todos.get_todo!(id, user.id)
        with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
