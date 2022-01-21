defmodule TodoJsonApi.TodosTest do
  use TodoJsonApi.DataCase

  alias TodoJsonApi.Todos

  describe "todos" do
    alias TodoJsonApi.Todos.Todo

    import TodoJsonApi.TodosFixtures

    @invalid_priority_attrs %{
      "details" => "some details",
      "is_complete" => false,
      "priority" => 5,
      "task" => "some task"
    }

    @invalid_nil_with_priority_attrs %{
      "details" => nil,
      "is_complete" => nil,
      "priority" => 1,
      "task" => nil
    }

    @invalid_nil_attrs %{
      "details" => nil,
      "is_complete" => nil,
      "priority" => nil,
      "task" => nil
    }

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{
        "details" => "some details",
        "is_complete" => true,
        "priority" => 1,
        "task" => "some task"
      }

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.details == "some details"
      assert todo.is_complete == true
      assert todo.priority == 1
      assert todo.task == "some task"
    end

    test "create_todo/1 with invalid data returns invalid priority range" do
      assert %{error: "Assigned 'priority' [5] is out of allowed range [1 to 1]."} =
               Todos.create_todo(@invalid_priority_attrs)
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_nil_with_priority_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()

      update_attrs = %{
        details: "some updated details",
        is_complete: false,
        priority: 2,
        task: "some updated task"
      }

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.details == "some updated details"
      assert todo.is_complete == false
      assert todo.priority == 2
      assert todo.task == "some updated task"
    end

    test "update_todo/2 with invalid data returns error priority out of allowed range" do
      todo = todo_fixture()

      assert %{error: "Assigned 'priority' [] is out of allowed range [1 to 1]."} =
               Todos.update_todo(todo, @invalid_nil_attrs)

      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert %{error: "Todo not found."} = Todos.get_todo!(todo.id)
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
