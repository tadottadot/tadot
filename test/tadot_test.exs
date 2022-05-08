defmodule TadotTest do
  use ExUnit.Case
  doctest Tadot

  describe "version/0" do
    @version Mix.Project.config()[:version]

    test "returns current version" do
      assert Tadot.version() == @version
    end
  end
end
