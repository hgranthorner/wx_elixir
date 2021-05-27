defmodule WxElixir.Task.Store do
  use Agent
  alias WxElixir.Task

  def start_link(initial_value) when is_map(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Gets all tasks stored in the store.
  """
  @spec get_tasks() :: [Task.t()]
  def get_tasks do
    Agent.get(__MODULE__, fn state -> Map.values(state) end)
  end

  @doc """
  Gets a specific task by name that's stored in the store.
  Returns {:ok, task} or :error if not found.
  """
  @spec get_task(String.t()) :: {:ok, Task.t()} | :error
  def get_task(name) when is_binary(name) do
    Agent.get(__MODULE__, fn state -> Map.fetch(state, name) end)
  end

  @doc """
  Adds or updates an existing task.
  """
  @spec put(Task.t()) :: :ok
  def put(task) when is_struct(task, Task) do
    Agent.update(__MODULE__, fn state -> Map.put(state, task.name, task) end)
  end

  @doc """
  Checks if task exists.
  """
  @spec exists?(String.t()) :: boolean()
  def exists?(name) when is_binary(name) do
    case Agent.get(__MODULE__, fn state -> Map.fetch(state, name) end) do
      {:ok, _} ->
        true

      _ ->
        false
    end
  end
end
