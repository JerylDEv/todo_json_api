defmodule TodoJsonApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :task, :string
      add :priority, :integer
      add :details, :string
      add :is_complete, :boolean, default: false, null: false

      timestamps()
    end
  end
end
