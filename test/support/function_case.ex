defmodule TestFunctionCase do
  def hello() do
    case true do
      true -> IO.puts("true")
      false -> IO.puts("false")
    end
  end

  def hello(1) do
    IO.puts(1)
  end

  def hello(msg) do
    IO.puts(msg)

    Enum.filter([1, 2, 3, 4], fn
      x when x < 3 -> rem(x, 2) == 0
      _x -> true
    end)
  end

  def hello2(msg) do
    IO.puts(msg)

    case {1, 2} do
      {i1, i2} when is_integer(i1) and is_integer(i2) ->
        {_, i, _} = {1, 2, 3}
        i1 + i2 + i

      _ ->
        IO.puts("not numbers")
    end
  end

  def hello3(l1) when is_list(l1) do
    l1
    |> Enum.filter(fn x -> rem(x, 2) == 0 end)
    |> Enum.map(&(&1 * 2))
  end

  def convert_param({:cons, _ln, c1, c2}) do
    case {convert_param(c1), convert_param(c2)} do
      {cc1, cc2} when is_tuple(cc1) and is_tuple(cc2) ->
        {_, [line: ln2], _} = cc1
        [{:|, [line: ln2], [cc1, cc2]}]

      {cc1, cc2} ->
        [cc1 | cc2]
    end
  end
end
