defmodule WxElixir.Gui do
  @behaviour :wx_object
  use WxElixir.Macros

  @title "Tasks"

  def start_link(_opts) do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def init(_args \\ []) do
    {_wx, frame, %{list: list} = state} = WxElixir.Gui.Designer.setup_gui(@title)

    for task <- Store.get_tasks() do
      append_to_list_box(list, task.name)
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
    %{name_input: name_input, list: list, button: button, notes: notes} = state
  ) do
    %Task{name: task_name} =
      name_input
      |> :wxTextCtrl.getValue()
      |> to_string()
      |> Task.new()
      |> Store.put()

    previous_selection = :wxControlWithItems.getStringSelection(list)

    append_to_list_box(list, task_name)

    if previous_selection != '' do
      true = :wxControlWithItems.setStringSelection(list, previous_selection)
    else
      true = :wxControlWithItems.setStringSelection(list, task_name)
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

  defevent(:notes, :command_text_updated, text, %{list: list} = state) do
    selection = :wxControlWithItems.getStringSelection(list) |> to_string()

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

  defp append_to_list_box(list, text) do
    count = :wxListBox.getCount(list)
    :ok = :wxListBox.insertItems(list, [text], count)
    list
  end
end
