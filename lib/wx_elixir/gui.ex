defmodule WxElixir.Gui do
  # Copy pasted from https://gist.github.com/rlipscombe/5f400451706efde62acbbd80700a6b7c
  @behaviour :wx_object
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

  def handle_event({:wx, _id, _ref, _userData, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  def handle_event(
        {:wx, _event_sender_id, _event_handler, _userData,
         {:wxCommand, :command_button_clicked, _, _, _}} = _thing,
        %{name_input: name_input, box: box} = state
      ) do
    text = name_input |> :wxTextCtrl.getValue()

    :ok =
      text
      |> to_string()
      |> Task.new()
      |> Store.put()

    :ok = :wxListBox.insertItems(box, [text], 0)
    :ok = :wxTextCtrl.setValue(name_input, '')
    {:noreply, state}
  end

  def handle_event(
        {:wx, _, _, :name_input, {_, :command_text_updated, text, _, _}},
        %{button: button} = state
      ) do
    if Store.exists?(to_string(text)) do
      :wxButton.disable(button)
    else
      :wxButton.enable(button)
    end

    {:noreply, state}
  end

  def handle_event(
        {:wx, _, _, :notes, {_, :command_text_updated, text, _, _}},
        %{box: box} = state
      ) do
    selection = :wxControlWithItems.getStringSelection(box) |> to_string()

    if Store.exists?(selection) do
      str =
        text
        |> to_string()

      Store.set_notes(selection, str)
    end

    {:noreply, state}
  end

  def handle_event(
        {:wx, _, _, :item_selected, {_, :command_listbox_selected, text, _, _}},
        %{notes: notes} = state
      ) do
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
