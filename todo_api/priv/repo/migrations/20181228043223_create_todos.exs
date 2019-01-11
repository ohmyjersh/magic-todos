defmodule TodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
