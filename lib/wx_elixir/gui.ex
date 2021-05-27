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
    wx = :wx.new()
    frame = :wxFrame.new(wx, 1, @title)

    :wxFrame.connect(frame, :close_window)

    button = :wxButton.new(frame, 420, label: 'enter')
    text = :wxTextCtrl.new(frame, :wx_const.id_any())
    sizer = :wxBoxSizer.new(:wx_const.vertical())
    box = :wxListBox.new(frame, :wx_const.id_any())

    :wxSizer.add(sizer, text, flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()), border: 5)
    :wxSizer.add(sizer, button, flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()), border: 5)
    :wxSizer.add(sizer, box, flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()), border: 5)

    :wxWindow.setSizer(frame, sizer)
    :wxSizer.setSizeHints(sizer, frame)

    :wxButton.connect(
      button,
      :command_button_clicked,
      userData: %{text: text}
    )

    :wxTextCtrl.connect(
      text,
      :command_text_updated
      userData: :name_input
    )

    :wxFrame.show(frame)

    state = %{frame: frame, sizer: sizer, button: button, text: text, box: box}
    {frame, state}
  end

  def handle_event({:wx, _id, _ref, _userData, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  def handle_event(
        {:wx, _event_sender_id, _event_handler, _userData,
         {:wxCommand, :command_button_clicked, _, _, _}} = _thing,
        %{text: textbox, box: box} = state
      ) do
    text = textbox |> :wxTextCtrl.getValue()

    :ok =
      text
      |> to_string()
      |> Task.new()
      |> Store.put()

    :ok = :wxListBox.insertItems(box, [text], 0)
    :ok = :wxTextCtrl.setValue(textbox, '')
    {:noreply, state}
  end

  def handle_event(
        {:wx, _, _, _, {_, :command_text_updated, text, _, _}},
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
        thing,
        state
      ) do
    IO.inspect(thing)
    {:noreply, state}
  end
end
