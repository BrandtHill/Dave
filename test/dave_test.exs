defmodule DaveTest do
  use ExUnit.Case
  doctest Dave

  test "Dave.max_protocol_version/0" do
    assert Dave.max_protocol_version == 1
  end
end
