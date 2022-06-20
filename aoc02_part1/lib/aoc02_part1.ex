defmodule Aoc02Part1 do
  @moduledoc """
  Documentation for `Aoc02Part1`.
  """

  def part_one(path) do
    try do
      extractInputs(path)
      |> calculate_position_values()
      |> multiplying_positions()
    rescue
      error -> error
    end
  end

  @doc """
  output: a list of maps -> [{step, value}, {step, value}, ...]
  """
  defp extractInputs(path) do
    File.read(path)
    |> case do
      {:ok, content} ->
        String.split(content, "\n", trim: true)
        |> Enum.map(fn x ->
          # example of x: "forward 8"
          [step, value] = String.split(x, " ")
          {step, String.to_integer(value)}
        end)

      {:error, _} ->
        {:error, "No se pudo leer el archivo"}
    end
  end

  @doc """
  Sum & rest position values
  output: %{horizontal: 15, depth: 10}
  """
  defp calculate_position_values(planned_course) do
    forward_values =
      Enum.filter(planned_course, fn {step, _value} -> step == "forward" end)
      |> Enum.map(fn {_step, value} -> value end)
      |> Enum.sum()

    down_values =
      Enum.filter(planned_course, fn {step, _value} -> step == "down" end)
      |> Enum.map(fn {_step, value} -> value end)
      |> Enum.sum()

    up_values =
      Enum.filter(planned_course, fn {step, _value} -> step == "up" end)
      |> Enum.map(fn {_step, value} -> value end)
      |> Enum.sum()

    %{horizontal: forward_values, depth: down_values - up_values}
  end

  defp multiplying_positions(%{horizontal: horizontal, depth: depth}) do
    {:ok, horizontal * depth}
  end

  def part_two(path) do
    try do
      extractInputs(path)
      |> calc_depth()
      |> multiplying_positions()
    rescue
      error -> error
    end
  end

  def calc_depth(planned_course) do
    planned_course
    |> Enum.reduce(
      %{horizontal: 0, depth: 0, aim: 0},
      fn {step, value}, %{horizontal: h, depth: d, aim: a} ->
        calc_aim({step, value}, %{horizontal: h, depth: d, aim: a})
      end
    )
  end

  defp calc_aim({step, value}, %{horizontal: h, depth: d, aim: a}) do
    case step do
      "up" ->
        %{horizontal: h, depth: d, aim: a - value}

      "down" ->
        %{horizontal: h, depth: d, aim: a + value}

      "forward" ->
        %{horizontal: h + value, depth: d + a * value, aim: a}
    end
  end
end
