defmodule WxElixir.Task do
  alias __MODULE__

  defstruct [
    :name,
    status: "Paused",
    notes: "",
    timestamps: []
  ]

  @type t :: %Task{
          name: String.t(),
          status: String.t(),
          notes: String.t(),
          timestamps: [{DateTime.t(), DateTime.t() | nil}]
        }

  @doc """
  Creates a new task with a given name.

  ## Examples

    iex> WxElixir.Task.new("a task")
    %WxElixir.Task{name: "a task", status: "Paused", notes: "", timestamps: []}

  """
  @spec new(String.t()) :: t()
  def new(name) when is_binary(name) do
    %Task{name: name}
  end

  @doc """
  Activates an existing task. This updates the tasks status and adds a new record to the timestamp list.
  If the task is already active, nothing happens and the task is returned.

  Returns Task.

  ## Examples

    iex> WxElixir.Task.new("a task") |> WxElixir.Task.activate()
    %WxElixir.Task{name: "a task", status: "Active", notes: "", timestamps: [{DateTime.utc_now() |> DateTime.truncate(:second), nil}]}
    
  """
  @spec activate(t()) :: t()
  def activate(task) when is_struct(task, Task) do
    case String.downcase(task.status) do
      "active" ->
        task

      _ ->
        %Task{
          task
          | status: "Active",
            timestamps: [
              {DateTime.utc_now() |> DateTime.truncate(:second), nil} | task.timestamps
            ]
        }
    end
  end

  @doc """
  Pauses a running task. This closes out the active timestamp tuple and updates the task status.
  If the task is already paused, nothing happens and the task is returned.

  ## Examples

    iex Task.new("a task") |> Task.activate() |> Task.pause()
    %Task{name: "a task", status: "Paused"}

  """
  @spec pause(t()) :: t()
  def pause(task) when is_struct(task, Task) do
    case String.downcase(task.status) do
      "paused" ->
        task

      _ ->
        %Task{
          task
          | status: "Paused",
            timestamps:
              Enum.map(
                task.timestamps,
                fn {start_dt, end_dt} ->
                  case end_dt do
                    nil ->
                      {start_dt, DateTime.utc_now()}

                    _ ->
                      {start_dt, end_dt}
                  end
                end
              )
        }
    end
  end

  def fetch(task, key), do: Map.fetch(task, key)
  def get_and_update(task, key, func), do: Map.get_and_update(task, key, func)
  def pop(data, key), do: Map.pop(data, key)
end
