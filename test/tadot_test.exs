defmodule TadotTest do
  use ExUnit.Case
  doctest Tadot

  test "greets the world" do
    assert Tadot.hello() == :world
  end
end
