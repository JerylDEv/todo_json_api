defmodule TodoJsonApiWeb.TodoControllerTest do
  use TodoJsonApiWeb.ConnCase

  import TodoJsonApi.TodosFixtures

  alias TodoJsonApi.Todos.Todo

  @create_attrs %{
    details: "some details",
    is_complete: true,
    priority: 1,
    task: "some task"
  }

  @update_attrs %{
    details: "some updated details",
    is_complete: false,
    priority: 1,
    task: "some updated task"
  }

  @invalid_attrs %{details: nil, is_complete: nil, priority: nil, task: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get(conn, Routes.todo_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "details" => "some details",
               "is_complete" => true,
               "priority" => 1,
               "task" => "some task"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.todo_path(conn, :create), todo: @invalid_attrs)
      assert json_response(conn, 400) == %{"error" => "Invalid todo values"}
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.todo_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "details" => "some updated details",
               "is_complete" => false,
               "priority" => 1,
               "task" => "some updated task"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, Routes.todo_path(conn, :update, todo), todo: @invalid_attrs)

      assert json_response(conn, 400) == %{"error" => "Invalid todo values"}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn_1 = delete(conn, Routes.todo_path(conn, :delete, todo))

      assert response(conn_1, 200) ==
               "{\"message\":\"Todo '#{todo.id}' was deleted.\"}"

      conn_2 = get(conn, Routes.todo_path(conn, :show, todo))

      assert response(conn_2, 400) ==
               "{\"error\":\"Todo not found.\"}"
    end
  end

  defp create_todo(_) do
    todo = todo_fixture()
    %{todo: todo}
  end
end
