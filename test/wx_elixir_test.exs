defmodule WxElixirTest do
  use ExUnit.Case
  doctest WxElixir

  test "greets the world" do
    assert WxElixir.hello() == :world
  end
end
