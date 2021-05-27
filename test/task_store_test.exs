defmodule TaskStoreTest do
  use ExUnit.Case
  alias WxElixir.Task
  alias WxElixir.Task.Store

  setup do
    _pid = start_supervised!({Store, %{}})
    :ok
  end

  test "starts" do
    tasks = Store.get_tasks()
    assert length(tasks) == 0
  end

  test "can add tasks" do
    :ok = Store.put(Task.new("a task"))
    tasks = Store.get_tasks()
    assert length(tasks) == 1
  end

  test "can get a specific task" do
    :ok = Store.put(Task.new(" a task"))
    {:ok, task} = Store.get_task(" a task")
    assert task.name == " a task"
  end

  test "can check if a task exists" do
    :ok = Store.put(Task.new("a task"))
    assert Store.exists?("a task") == true
  end

  test "can add notes to a task" do
    :ok = Store.put(Task.new("a task"))
    :ok = Store.set_notes("a task", "hello")
    :ok = Store.set_notes("a task", "hello again")
    {:ok, task} = Store.get_task("a task")
    assert task.notes == "hello again"
  end
end
