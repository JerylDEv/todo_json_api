defmodule TodoJsonApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoJsonApi.Repo

  alias TodoJsonApi.Todos.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    from(
      item in Todo,
      order_by: [asc: :priority]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    if Map.has_key?(attrs, "priority") do
      proposed_priority_change = Map.get(attrs, "priority")
      current_record_count = Repo.aggregate(from(t in Todo), :count)
      latest_index = current_record_count + 1

      if current_record_count == 0 do
        %Todo{}
        |> Todo.changeset(attrs)
        |> Repo.insert()
      else
        if latest_index >= proposed_priority_change do
          {:ok, %Todo{} = todo} =
            %Todo{}
            |> Todo.changeset(attrs)
            |> Repo.insert()

          current_todo_id = todo.id
          move_todo(current_todo_id, proposed_priority_change)

          todo
          |> Todo.changeset(attrs)
          |> Repo.update()
        end
      end
    else
      current_record_count = Repo.aggregate(from(t in Todo), :count)
      latest_index = current_record_count + 1
      updated_attrs = Map.put(attrs, "priority", latest_index)

      update_priority()

      %Todo{}
      |> Todo.changeset(updated_attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    if Map.has_key?(attrs, "priority") do
      proposed_priority_change = Map.get(attrs, "priority")
      current_record_count = Repo.aggregate(from(t in Todo), :count)

      if current_record_count >= proposed_priority_change do
        current_todo_id = todo.id
        move_todo(current_todo_id, proposed_priority_change)

        todo
        |> Todo.changeset(attrs)
        |> Repo.update()
      end
    else
      todo
      |> Todo.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    delete_result = Repo.delete(todo)

    update_priority()

    delete_result
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  # Reorders the list of items in Todo table based on priority,
  # in ascending manner
  defp update_priority() do
    Repo.all(
      from(
        item in Todo,
        order_by: [asc: :priority]
      )
    )
    |> Enum.with_index(1)
    |> Enum.map(fn {item, index} ->
      item
      |> Todo.changeset(%{priority: index})
      |> Repo.update()
    end)
  end

  # Move the todo in the todo list based on index
  # Updates the todo priority afterwards
  defp move_todo(current_todo_id, proposed_priority_change) do
    todo_list =
      Repo.all(
        from(
          item in Todo,
          order_by: [asc: :priority]
        )
      )

    current_todo_index =
      todo_list
      |> Enum.find_index(fn item ->
        item.id == current_todo_id
      end)

    updated_todo_list =
      todo_list
      |> Enum.slide(current_todo_index, proposed_priority_change - 1)

    updated_todo_list
    |> Enum.with_index(1)
    |> Enum.map(fn {item, index} ->
      item
      |> Todo.changeset(%{priority: index})
      |> Repo.update()
    end)
  end
end
