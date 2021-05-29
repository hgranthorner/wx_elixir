defmodule WxElixir.Gui.Designer do
  def setup_gui(title) when is_binary(title) do
    wx = :wx.new()
    frame = :wxFrame.new(wx, 1, title)

    :wxFrame.connect(frame, :close_window)

    # Left side elements
    button = :wxButton.new(frame, 420, label: 'enter')
    name_input = :wxTextCtrl.new(frame, :wx_const.id_any())
    list = :wxListBox.new(frame, :wx_const.id_any())
    panel_sizer = :wxBoxSizer.new(:wx_const.vertical())

    :wxSizer.add(panel_sizer, name_input,
      flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()),
      border: 5
    )

    :wxSizer.add(panel_sizer, button,
      flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()),
      border: 5
    )

    :wxSizer.add(panel_sizer, list,
      flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()),
      border: 5
    )

    # Task header
    status_list = :wxComboBox.new(frame, :wx_const.id_any(), style: :wx_const.cb_readonly())
    notes = :wxTextCtrl.new(frame, :wx_const.id_any(), style: :wx_const.te_multiline())

    task_header_sizer = :wxBoxSizer.new(:wx_const.horizontal())

    :wxBoxSizer.add(task_header_sizer, status_list,
      flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()),
      border: 5
    )

    # Overall Task section
    task_sizer = :wxBoxSizer.new(:wx_const.vertical())

    :wxSizer.add(task_sizer, task_header_sizer, proportion: 1)

    :wxSizer.add(task_sizer, notes,
      flag: Bitwise.bor(:wx_const.expand(), :wx_const.all()),
      border: 5,
      proportion: 3
    )

    # Frame sizer
    main_sizer = :wxBoxSizer.new(:wx_const.horizontal())

    :wxSizer.add(
      main_sizer,
      panel_sizer,
      proportion: 1
    )

    :wxSizer.add(
      main_sizer,
      task_sizer,
      proportion: 2
    )

    :wxWindow.setSizer(frame, main_sizer)
    :wxSizer.setSizeHints(main_sizer, frame)

    :wxButton.connect(
      button,
      :command_button_clicked,
      userData: :add_task
    )

    :wxTextCtrl.connect(
      name_input,
      :command_text_updated,
      userData: :name_input
    )

    :wxTextCtrl.connect(
      notes,
      :command_text_updated,
      userData: :notes
    )

    :wxListBox.connect(
      list,
      :command_listbox_selected,
      userData: :item_selected
    )

    :wxComboBox.insertStrings(
      status_list,
      WxElixir.Task.statuses() |> Enum.map(&to_charlist/1),
      0
    )

    :wxButton.disable(button)
    :wxTextCtrl.disable(notes)

    :wxFrame.show(frame)

    state = %{
      frame: frame,
      sizer: panel_sizer,
      button: button,
      name_input: name_input,
      list: list,
      notes: notes
    }

    {wx, frame, state}
  end
end
