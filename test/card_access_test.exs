defmodule CardAccessTest do
  use ExUnit.Case
  doctest CardAccess

  test "greets the world" do
    assert CardAccess.hello() == :world
  end
end
