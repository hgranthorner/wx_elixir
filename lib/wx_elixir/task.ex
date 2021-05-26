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
  Pauses a running task.
  """
  def pause do
  end
end
