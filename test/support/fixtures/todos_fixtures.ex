defmodule TodoJsonApi.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoJsonApi.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        "details" => "some details",
        "is_complete" => true,
        "priority" => 1,
        "task" => "some task"
      })
      |> TodoJsonApi.Todos.create_todo()

    todo
  end
end
