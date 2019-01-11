defmodule TodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todos" do
    field :completed, :boolean, default: false
    field :description, :string
    field :user_id, :binary_id
    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:description, :completed, :user_id])
    |> validate_required([:description, :completed, :user_id])
  end
end
