defmodule Aoc02Part1Test do
  use ExUnit.Case
  doctest Aoc02Part1

  @path_planned_course "inputTest.txt"

  test "calc horizontal & depth position" do
    result = Aoc02Part1.part_one(@path_planned_course)
    assert {:ok, 150} = result
  end

  test "calc aim position" do
    result = Aoc02Part1.part_two(@path_planned_course)
    assert {:ok, 900} = result
  end
end
