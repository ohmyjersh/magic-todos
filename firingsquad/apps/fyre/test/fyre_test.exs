defmodule FyreTest do
  use ExUnit.Case
  doctest Fyre

  test "greets the world" do
    assert Fyre.hello() == :world
  end
end
