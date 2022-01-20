defmodule TodoJsonApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todos" do
    field :details, :string
    field :is_complete, :boolean, default: false
    field :priority, :integer
    field :task, :string

    timestamps()
  end

  @doc false
  def create_changeset(todo, attrs, current_record_count) do
    # need to add validate_inclusion based on the current count in table + 1
    todo
    |> cast(attrs, [:task, :priority, :details, :is_complete])
    |> change(priority: current_record_count + 1)
    |> validate_required([:task, :priority, :details, :is_complete])
  end

  def changeset(todo, attrs) do
    # need to add validate_inclusion based on the current count in table + 1
    todo
    |> cast(attrs, [:task, :priority, :details, :is_complete])
    |> validate_required([:task, :priority, :details, :is_complete])
  end
end
