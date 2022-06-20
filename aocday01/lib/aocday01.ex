defmodule Aocday01 do
  @moduledoc """
  Documentation for `Aocday01`.
  """
  def start do
    get_input()
    |> calculate_measurements()
    |> parse_result()
  end

  defp get_input() do
    File.read("lib/input.txt")
    |> case do
      {:ok, content} ->
        String.split(content, "\n", trim: true) |> Enum.map(fn x -> String.to_integer(x) end)

      {:error, _} ->
        {:error, "No se pudo leer el archivo"}
    end
  end

  defp calculate_measurements(input) do
    Enum.reduce(input, %{previous: nil, count: 0}, fn current_input,
                                                      %{previous: previous, count: count} ->
      check_previous_number(previous, current_input, count)
    end)
  end

  # to handle first iteration only update the previous field
  defp check_previous_number(nil, current_input, count) do
    %{previous: current_input, count: 0}
  end

  # to handle next iterations
  defp check_previous_number(previous, current_input, count) do
    if previous <= current_input do
      update_count = count + 1
      %{previous: current_input, count: update_count}
    else
      %{previous: current_input, count: count}
    end
  end

  defp parse_result(%{count: count}), do: {:ok, count}
  defp parse_result(_), do: {:error, "No se pudo procesar"}

  def perform_part_two do
    get_input()
    |> group_measurements([])
    |> compare_and_tag_measurements([], -1)
    |> count_increased()
  end
  def group_measurements([a, b, c | tail], acc) do
    new_value = a + b + c
    acc = acc ++ [new_value]

    input = [b] ++ [c] ++ tail

    group_measurements(input, acc)
  end

  def group_measurements([_a, _b], acc), do: acc

  @spec compare_and_tag_measurements(list, list, integer) :: list
  def compare_and_tag_measurements(_input = [current | tail], acc, prev),
    do: compare_and_tag_measurements(current, acc, prev, tail)

  def compare_and_tag_measurements([], acc, _prev), do: acc

  def compare_and_tag_measurements(current, acc, -1, tail) do
    acc = acc ++ [{current, :na}]
    compare_and_tag_measurements(tail, acc, current)
  end

  def compare_and_tag_measurements(current, acc, prev, tail) when current > prev do
    acc = acc ++ [{current, :increased}]
    compare_and_tag_measurements(tail, acc, current)
  end

  def compare_and_tag_measurements(current, acc, prev, tail) when current < prev do
    acc = acc ++ [{current, :decreased}]
    compare_and_tag_measurements(tail, acc, current)
  end

  def compare_and_tag_measurements(current, acc, _prev, tail) do
    acc = acc ++ [{current, :no_change}]
    compare_and_tag_measurements(tail, acc, current)
  end

  @spec count_increased(list) :: integer
  def count_increased(list) do
    Enum.reduce(list, 0, fn {_val, tag}, increased ->
      if tag == :increased, do: increased + 1, else: increased
    end)
  end
end
