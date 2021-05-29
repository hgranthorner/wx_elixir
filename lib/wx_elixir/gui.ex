defmodule WxElixir.Gui do
  @behaviour :wx_object
  use WxElixir.Macros
  alias WxElixir.Task.Store
  alias WxElixir.Task

  @title "Tasks"

  def start_link(_opts) do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def init(_args \\ []) do
    {_wx, frame, %{box: box} = state} = WxElixir.Gui.Designer.setup_gui(@title)

    for task <- Store.get_tasks() do
      append_to_list_box(box, task.name)
    end

    {frame, state}
  end

  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  defevent(
    :add_task,
    :command_button_clicked,
    _,
    %{name_input: name_input, box: box, button: button, notes: notes} = state
  ) do
    %Task{name: task_name} =
      name_input
      |> :wxTextCtrl.getValue()
      |> to_string()
      |> Task.new()
      |> Store.put()

    previous_selection = :wxControlWithItems.getStringSelection(box)

    append_to_list_box(box, task_name)

    if previous_selection != '' do
      true = :wxControlWithItems.setStringSelection(box, previous_selection)
    else
      true = :wxControlWithItems.setStringSelection(box, task_name)
      :wxTextCtrl.enable(notes)
    end

    :ok = :wxTextCtrl.setValue(name_input, '')
    :wxButton.disable(button)
    {:noreply, state}
  end

  defevent(:name_input, :command_text_updated, text, %{button: button} = state) do
    if Store.exists?(to_string(text)) do
      :wxButton.disable(button)
    else
      :wxButton.enable(button)
    end

    {:noreply, state}
  end

  defevent(:notes, :command_text_updated, text, %{box: box} = state) do
    selection = :wxControlWithItems.getStringSelection(box) |> to_string()

    if Store.exists?(selection) do
      str =
        text
        |> to_string()

      Store.set_notes(selection, str)
    end

    {:noreply, state}
  end

  defevent(:item_selected, :command_listbox_selected, text, %{notes: notes} = state) do
    name = to_string(text)
    :wxTextCtrl.enable(notes)

    case Store.get_task(name) do
      {:ok, task} ->
        :wxTextCtrl.setValue(notes, to_charlist(task.notes))

      _ ->
        Store.put(Task.new(name))
        :wxTextCtrl.setValue(notes, '')
    end

    {:noreply, state}
  end

  def handle_event(
        thing,
        state
      ) do
    IO.inspect(thing)
    {:noreply, state}
  end

  defp append_to_list_box(box, text) do
    count = :wxListBox.getCount(box)
    :ok = :wxListBox.insertItems(box, [text], count)
    box
  end
end
