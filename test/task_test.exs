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

  test "can pause a task" do
    task =
      Task.new("a task")
      |> Task.activate()
      |> Task.pause()

    assert task.status == "Paused"
  end

  test "all timestamp tuples should be filled out" do
    task =
      Task.new("a task")
      |> Task.activate()

    unfinished_timestamps = Enum.filter(task.timestamps, fn {_, end_dt} -> end_dt == nil end)
    assert length(unfinished_timestamps) == 1

    task = Task.pause(task)

    unfinished_timestamps = Enum.filter(task.timestamps, fn {_, end_dt} -> end_dt == nil end)
    assert length(unfinished_timestamps) == 0
  end
end
