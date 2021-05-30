# WxElixir

Play around with wxwidgets in elixir. Feel free to use an example if you're also interested.

## To Run
```
mix run --no-halt
```

## Where this could go

I currently feel like I'm getting pulled in all directions at my job, and it might be nice to have some tool I can use to easily track my time. Maybe I could use this.

The idea would be that I could start a task by either typing in the name of the task and hitting start, or by selecting an existing task in a drop down. See mock.

## Steps to get there

1. Be able to add items based on an input - done
2. Be able to update those items with the correct time stamps
- Each item would be a struct with multiple time ranges, but one big ol' notes section
3. Be able to read and write those structs to disk (persistence)

## Issues
- automatically update status box status with selected task status
- change in status selection should update task status
- typing in task name field should automatically autofill to exiting task names if possible

## Completed Issues
- Selected text doesn't stay selected after an item is added - instead, the selection index stays the same as the item goes down
- Adding a task should automatically select it if no tasks exist yet.
- Notes should be disabled if a task is not selected.

## Notes

For missing macros on older versions of OTP, add this to the top of src/wx_const.erl:

%% OTP 24.0 stubs
-define(wxGRID_DRAW_BOX_RECT, 0).
-define(wxTEXT_ATTR_BULLET_NAME, 0).
-define(WXK_CATEGORY_JUMP, 0).
-define(wxGRID_DRAW_CELL_LINES, 0).
-define(wxSTB_SHOW_TIPS, 0).
-define(wxTEXT_ATTR_FONT_FAMILY, 0).
-define(wxTEXT_ATTR_BULLET_TEXT, 0).
-define(wxTEXT_ATTR_URL, 0).
-define(wxICON_AUTH_NEEDED, 0).
-define(WXK_CATEGORY_PAGING, 0).
-define(wxELLIPSIZE_FLAGS_EXPAND_TABS, 0).
-define(wxGRID_DRAW_COLS_HEADER, 0).
-define(wxSTB_ELLIPSIZE_END, 0).
-define(wxTEXT_ATTR_FONT_PIXEL_SIZE, 0).
-define(wxTEXT_ATTR_FONT_ENCODING, 0).
-define(wxTEXT_ATTR_BULLET_NUMBER, 0).
-define(wxTEXT_ATTR_CHARACTER_STYLE_NAME, 0).
-define(wxTOUCH_HORIZONTAL_PAN_GESTURE, 0).
-define(wxICON_NONE, 0).
-define(wxBRUSHSTYLE_BDIAGONAL_HATCH, 0).
-define(wxBRUSHSTYLE_CROSSDIAG_HATCH, 0).
-define(wxID_MDI_WINDOW_FIRST, 0).
-define(wxID_MDI_WINDOW_NEXT, 0).
-define(WXK_CATEGORY_ARROW, 0).
-define(wxPB_SMALL, 0).
-define(wxFONTENCODING_CP1361, 0).
-define(wxFONTENCODING_CP1258, 0).
-define(wxBITMAP_TYPE_TIFF, 0).
-define(wxBITMAP_TYPE_TIFF_RESOURCE, 0).
-define(wxELLIPSIZE_FLAGS_PROCESS_MNEMONICS, 0).
-define(wxGRID_FLOAT_FORMAT_FIXED, 0).
-define(wxGRID_DRAW_ROWS_HEADER, 0).
-define(wxSTB_SIZEGRIP, 0).
-define(wxTEXT_ATTR_FONT_POINT_SIZE, 0).
-define(wxTEXT_ATTR_FONT_STRIKETHROUGH, 0).
-define(wxTEXT_ATTR_BULLET_STYLE, 0).
-define(wxTEXT_ATTR_EFFECTS, 0).
-define(wxStrip_CJKMnemonics, 0).
-define(wxEXEC_NOEVENTS, 0).
-define(wxTOUCH_VERTICAL_PAN_GESTUREwxICON_NONE, 0).
-define(wxTOUCH_VERTICAL_PAN_GESTURE, 0).
