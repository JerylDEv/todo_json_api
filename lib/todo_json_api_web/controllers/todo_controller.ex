defmodule TodoJsonApiWeb.TodoController do
  use TodoJsonApiWeb, :controller

  alias TodoJsonApi.Todos
  alias TodoJsonApi.Todos.Todo

  action_fallback TodoJsonApiWeb.FallbackController

  def index(conn, _params) do
    todos = Todos.list_todos()
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <- Todos.create_todo(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.todo_path(conn, :show, todo))
      |> render("show.json", todo: todo)
    else
      error -> conn |> put_status(:bad_request) |> render("error.json", error)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)

    if Map.has_key?(todo, :error) do
      conn
      |> put_status(:bad_request)
      |> render("error.json", todo)
    else
      render(conn, "show.json", todo: todo)
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    if Map.has_key?(todo, :error) do
      conn
      |> put_status(:bad_request)
      |> render("error.json", todo)
    else
      with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
        render(conn, "show.json", todo: todo)
      else
        error ->
          conn
          |> put_status(:bad_request)
          |> render("error.json", error)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)

    if Map.has_key?(todo, :error) do
      conn
      |> put_status(:bad_request)
      |> render("error.json", todo)
    else
      with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
        render(conn, "deleted.json", message: "Todo '#{id}' was deleted.")
      end
    end
  end
end
