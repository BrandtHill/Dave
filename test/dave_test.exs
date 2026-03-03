defmodule DaveTest do
  use ExUnit.Case
  doctest Dave

  test "Dave.max_protocol_version/0" do
    assert Dave.max_protocol_version == 1
  end

  test "Dave.new_session/3" do
    assert is_reference(Dave.new_session(1, 1, 1))
  end
end
