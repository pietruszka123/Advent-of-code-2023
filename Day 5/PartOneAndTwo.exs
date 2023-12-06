partTwo = false

{_status, data} = File.read("./input.txt")
lines = String.replace(data, "\r", "") |> String.split("\n")

seeds =
  Enum.at(lines, 0)
  |> String.slice(7..-1)
  |> String.split(" ")
  |> Enum.map(fn e -> String.replace(e, ~r/[^0-9]/, "") end)
  |> Enum.map(fn e -> String.to_integer(e) end)

IO.puts(inspect(seeds))

seeds =
  if partTwo do
    Enum.chunk_every(seeds, 2) |> Enum.map(fn [a, b] -> [a, a + b - 1] end)
  else
    seeds
  end

IO.inspect(seeds, charlists: :as_lists, label: "seeds", limit: :infinity)

lines = Enum.drop(lines, 1)

# group lines until next line is empty
defmodule GroupLines do
  def by_empty_line([]), do: []

  def by_empty_line(lines) do
    {group, rest} = Enum.split_while(lines, fn line -> line != "" end)
    [group | by_empty_line(Enum.drop(rest, 1))]
  end
end

grouped_lines = GroupLines.by_empty_line(lines)

output =
  Enum.reduce(grouped_lines, seeds, fn group, acc ->
    case Enum.count(group) do
      0 ->
        acc

      _ ->
        nums = Enum.drop(group, 1)

        nums =
          Enum.map(nums, fn e ->
            String.split(e, " ") |> Enum.map(fn e -> String.to_integer(e) end)
          end)

        result =
          if partTwo do
            Stream.unfold(acc, fn left ->
              if Enum.count(left) == 0 do
                nil
              else
                {o, i} =
                  Enum.map(left, fn range ->
                    Enum.reduce_while(nums, {range, nil}, fn [cStart, bStart, bRange], acc2 ->
                      [aStart, aEnd] = range
                      bEnd = bStart + bRange

                      cond do
                        aStart >= bStart && aStart < bEnd ->
                          newStart = cStart + (aStart - bStart)

                          if aEnd < bEnd do
                            newEnd = cStart + (aEnd - bStart)
                            {:halt, {[newStart, newEnd], nil}}
                          else
                            newEnd = cStart + bRange - 1
                            {:halt, {[newStart, newEnd], [bEnd, aEnd]}}
                          end

                        aEnd >= bStart && aEnd < bEnd ->
                          newEnd = cStart + (aEnd - bStart)

                          if aStart > bStart do
                            newStart = cStart + (aStart - bStart)
                            {:halt, {[newStart, newEnd], nil}}
                          else
                            newStart = cStart
                            {:halt, {[newStart, newEnd], [aStart, bStart - 1]}}
                          end

                        true ->
                          {:cont, acc2}
                      end
                    end)
                  end)
                  |> Enum.reduce({[], []}, fn {out, newInput}, {o, n} ->
                    newInput =
                      if newInput == nil do
                        n
                      else
                        [[newInput] | n]
                      end

                    {[[out] | o], newInput}
                  end)

                i = List.flatten(i) |> Enum.chunk_every(2)

                {o, i}
              end
            end)
            |> Enum.to_list()
          else
            Enum.map(acc, fn e ->
              start =
                if partTwo do
                  e
                else
                  0
                end

              Enum.reduce(nums, start, fn [cStart, bStart, bRange], acc2 ->
                n = e - bStart + cStart

                if n >= cStart + bRange || n < cStart do
                  if acc2 == 0 do
                    acc2 = e
                  else
                    acc2
                  end
                else
                  acc2 = n
                end
              end)
            end)
          end

        result =
          if partTwo do
            List.flatten(result) |> Enum.chunk_every(2)
          else
            result
          end

        result
    end
  end)

output =
  if partTwo do
    Enum.map(output, fn [start, _range] -> start end) |> Enum.min()
  else
    Enum.min(output)
  end

IO.inspect(output, label: "output", charlists: :as_lists)
