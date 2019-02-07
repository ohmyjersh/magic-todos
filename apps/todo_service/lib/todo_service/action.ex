defmodule TodoService.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoService.{Todo,Repo}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todos" do
    field :completed, :boolean, default: false
    field :description, :string
    field :user_id, :binary_id
    timestamps()
  end
  @spec changeset(
          {map(), map()} | %{:__struct__ => atom(), optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:description, :completed, :user_id])
    |> validate_required([:description, :completed, :user_id])
  end

  def add(user_id, description, completed) do
    %Todo{}
    |> Todo.changeset(%{user_id: user_id, description: description, completed: completed})
    |> Repo.insert!
  end

  def get() do
    Repo.all(Todo)
  end
end
