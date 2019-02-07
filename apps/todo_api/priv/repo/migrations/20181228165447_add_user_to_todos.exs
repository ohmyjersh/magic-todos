defmodule TodoApi.Repo.Migrations.AddUserToTodos do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
    end
    create index(:todos, [:user_id])
  end
end
