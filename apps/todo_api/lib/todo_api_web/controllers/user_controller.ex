defmodule TodoApiWeb.UserController do
  use TodoApiWeb, :controller

  alias TodoApi.Accounts
  alias TodoApi.Accounts.User
  alias TodoApi.Guardian

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    mappedUser = %{"email" => user_params["email"], "password" => user_params["password"], "password_confirmation" => user_params["passwordConfirmation"]}
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    with {:ok, %User{} = user} <- Accounts.create_user(mappedUser),
        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("jwt.json", jwt: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
          conn |> render("jwt.json", jwt: token)
      {:error, :unauthorized} -> {:error, :unauthorized}
    end
  end

  def show(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      user -> render(conn, "show.json", user: user)
      {:error} -> {:error, :unauthorized}
    end
  end

  @spec update(any(), map()) :: any()
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
