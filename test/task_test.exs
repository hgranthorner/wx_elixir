defmodule TaskTest do
  use ExUnit.Case, async: true
  doctest WxElixir.Task
  alias WxElixir.Task

  test "can create" do
    task = Task.new("a task")
    assert task.name == "a task"
  end

  test "can activate" do
    task =
      Task.new("a task")
      |> Task.activate()

    assert task.status == "Active"
    assert length(task.timestamps) == 1
  end

  test "does nothing if task is already active" do
    task =
      Task.new("a task")
      |> Task.activate()

    new_task = Task.activate(task)

    assert new_task == task
  end
end
