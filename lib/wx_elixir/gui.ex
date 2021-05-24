defmodule WxElixir.Gui do
  # Copy pasted from https://gist.github.com/rlipscombe/5f400451706efde62acbbd80700a6b7c
  @behaviour :wx_object

  @title "Canvas Example"
  @size {600, 600}
  @wxID_ANY -1

  def start_link(_opts) do
    :wx_object.start_link(__MODULE__, [], [])
  end

  def init(_args \\ []) do
    wx = :wx.new()
    frame = :wxFrame.new(wx, -1, @title, size: @size)
    :wxFrame.connect(frame, :size)
    :wxFrame.connect(frame, :close_window)

    panel = :wxPanel.new(frame, [])
    :wxPanel.connect(panel, :paint, [:callback])

    button = :wxButton.new(frame, :wx_const.id_any(), label: 'button')
    text = :wxTextCtrl.new(frame, -1)

    sizer = :wxBoxSizer.new(8)
    :wxSizer.add(sizer,  button)
    :wxSizer.add(sizer,  text)

    :wxWindow.setSizer(frame, sizer)
    :wxSizer.setSizeHints(sizer, frame)


    :wxFrame.show(frame)

    state = %{panel: panel}
    {frame, state}
  end

  def handle_event({:wx, _, _, _, {:wxSize, :size, size, _}}, state = %{panel: panel}) do
    :wxPanel.setSize(panel, size)
    {:noreply, state}
  end

  def handle_event({:wx, _, _, _, {:wxClose, :close_window}}, state) do
    {:stop, :normal, state}
  end

  def handle_sync_event({:wx, _, _, _, {:wxPaint, :paint}}, _, _state = %{panel: panel}) do
    brush = :wxBrush.new()
    :wxBrush.setColour(brush, {255, 255, 255, 255})

    dc = :wxPaintDC.new(panel)
    :wxDC.setBackground(dc, brush)
    :wxDC.clear(dc)
    :wxPaintDC.destroy(dc)
    :ok
  end
end
