defmodule TodoApiWeb.Router do
  use TodoApiWeb, :router
  alias TodoApi.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", TodoApiWeb do
    pipe_through :api

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
    options "/sign_up", UserController, :options
    options "/sign_in", UserController, :options

  end

  scope "/api/v1", TodoApiWeb do
    pipe_through [:api, :jwt_authenticated]
    resources "/todos", TodoController, except: [:new, :edit]
    options "/todos", TodoController, :options
    post "/todos/delayed", DelayedController, :index
    options "/todos/delayed", DelayedController, :options
  end
end
