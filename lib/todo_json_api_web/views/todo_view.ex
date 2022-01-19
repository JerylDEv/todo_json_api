defmodule TodoJsonApiWeb.TodoView do
  use TodoJsonApiWeb, :view
  alias TodoJsonApiWeb.TodoView

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      task: todo.task,
      priority: todo.priority,
      details: todo.details,
      is_complete: todo.is_complete
    }
  end
end
