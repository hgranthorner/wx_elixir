defmodule WxElixir.Gui do
  # Copy pasted from https://gist.github.com/rlipscombe/5f400451706efde62acbbd80700a6b7c
  @behaviour :wx_object

  @title "Canvas Example"

  def start_link(_opts) do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def init(_args \\ []) do
    wx = :wx.new()
    frame = :wxFrame.new(wx, 1, @title)

    :wxFrame.connect(frame, :close_window)

    button = :wxButton.new(frame, :wx_const.id_any(), label: 'button')
    text = :wxTextCtrl.new(frame, :wx_const.id_any())

    sizer = :wxBoxSizer.new(:wx_const.vertical())
    :wxSizer.add(sizer, button)
    :wxSizer.add(sizer, text)

    :wxWindow.setSizer(frame, sizer)
    :wxSizer.setSizeHints(sizer, frame)

    :wxButton.connect(
      button,
      :command_button_clicked,
      callback: &handle_click/2,
      userData: %{text: text}
    )

    :wxFrame.show(frame)

    state = %{button: button, text: text}
    {frame, state}
  end

  def handle_click({:wx, _id, _button, %{text: text}, _click_info}, _command_info) do
    text
    |> :wxTextCtrl.getValue()
    |> IO.inspect()
  end

  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end
end
