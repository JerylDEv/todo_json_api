defmodule TodoJsonApi.TodosTest do
  use TodoJsonApi.DataCase

  alias TodoJsonApi.Todos

  describe "todos" do
    alias TodoJsonApi.Todos.Todo

    import TodoJsonApi.TodosFixtures

    @invalid_attrs %{details: nil, is_complete: nil, priority: nil, task: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{details: "some details", is_complete: true, priority: 42, task: "some task"}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.details == "some details"
      assert todo.is_complete == true
      assert todo.priority == 42
      assert todo.task == "some task"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{details: "some updated details", is_complete: false, priority: 43, task: "some updated task"}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.details == "some updated details"
      assert todo.is_complete == false
      assert todo.priority == 43
      assert todo.task == "some updated task"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
