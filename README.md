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

1. Be able to add items based on an input
2. Be able to update those items with the correct time stamps
- Each item would be a struct with multiple time ranges, but one big ol' notes section
3. Be able to read and write those structs to disk (persistence)