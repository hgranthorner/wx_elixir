defmodule WxElixir.Task.Store do
  use Agent
  alias WxElixir.Task
  @path "./data"

  @doc """
  Accepts a list of keyword arguments. Accepted keywords:

  write_to_disk: boolean
  Determines whether the store should write to disk or not.
  """
  def start_link(opts \\ []) when is_list(opts) do
    write_to_disk? = Keyword.get(opts, :write_to_disk, false)

    if write_to_disk? do
      File.mkdir("./data")

      task_map =
        File.ls!("./data")
        |> Enum.reduce(%{}, fn file_name, acc -> load_existing_data(file_name, acc) end)

      Agent.start_link(fn -> Map.put(task_map, :write_to_disk, write_to_disk?) end,
        name: __MODULE__
      )
    else
      Agent.start_link(fn -> %{write_to_disk: write_to_disk?} end, name: __MODULE__)
    end
  end

  @doc """
  Gets all tasks stored in the store.
  """
  @spec get_tasks() :: [Task.t()]
  def get_tasks do
    Agent.get(__MODULE__, fn state -> Map.values(state) |> Enum.filter(&is_map/1) end)
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
  @spec put(Task.t()) :: Task.t()
  def put(task) when is_struct(task, Task) do
    write_to_disk? =
      Agent.get_and_update(__MODULE__, fn state ->
        {state[:write_to_disk], Map.put(state, task.name, task)}
      end)

    if write_to_disk? do
      write_to_disk(task)
    end

    task
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

  @doc """
  Adds notes to an existing task.
  If the task exists, :ok is returned. If the task does not exist, :error is returned.
  """
  @spec set_notes(String.t(), String.t()) :: Task.t()
  def set_notes(name, notes) when is_binary(name) and is_binary(notes) do
    if exists?(name) do
      {task, write_to_disk?} =
        Agent.get_and_update(__MODULE__, fn state ->
          state = Map.update!(state, name, &%Task{&1 | notes: notes})
          {{state[name], state[:write_to_disk]}, state}
        end)

      if write_to_disk? do
        write_to_disk(task)
      end

      task
    else
      :error
    end
  end

  defp load_existing_data(file_name, data) when is_binary(file_name) and is_map(data) do
    task =
      File.read!("#{@path}/#{file_name}")
      |> :erlang.binary_to_term()

    Map.put(data, file_name, task)
  end

  defp write_to_disk(task) do
    spawn(fn ->
      bin = :erlang.term_to_binary(task)
      path = "#{@path}/#{task[:name]}"
      File.write!(path, bin)
    end)
  end
end
