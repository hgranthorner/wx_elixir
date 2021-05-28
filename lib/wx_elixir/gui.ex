defmodule WxElixir.Gui do
  # Copy pasted from https://gist.github.com/rlipscombe/5f400451706efde62acbbd80700a6b7c
  @behaviour :wx_object
  use WxElixir.Macros
  alias WxElixir.Task.Store
  alias WxElixir.Task

  @title "Canvas Example"

  def start_link(_opts) do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def init(_args \\ []) do
    {_wx, frame, state} = WxElixir.Gui.Designer.setup_gui(@title)
    {frame, state}
  end

  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  defevent(:add_task, :command_button_clicked, _, %{name_input: name_input, box: box} = state) do
    text = name_input |> :wxTextCtrl.getValue()

    :ok =
      text
      |> to_string()
      |> Task.new()
      |> Store.put()

    count = :wxListBox.getCount(box)
    previous_selection = :wxControlWithItems.getStringSelection(box)

    :ok = :wxListBox.insertItems(box, [text], count)

    if previous_selection != '' do
      true = :wxControlWithItems.setStringSelection(box, previous_selection)
    else
      true = :wxControlWithItems.setStringSelection(box, text)
    end

    :ok = :wxTextCtrl.setValue(name_input, '')
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
end
