defmodule BeamToExAstTestUtils do
  def clean_ast({:defmodule, line1, [c1, p1]}) do
    {:defmodule, line1, [c1, clean_ast(p1)]}
  end

  def clean_ast({:def, line1, l1}) do
    {:def, line1, Enum.map(l1, &clean_ast/1)}
  end

  # I can't know if it was a pipe or not
  def clean_ast({:|>, _line1, [p1, {c1, line2, nil}]}) do
    {c1, line2, Enum.concat([p1], [])}
  end

  def clean_ast({:|>, _line1, [p1, {c1, line2, p2}]}) do
    {c1, line2, Enum.concat([clean_ast(p1)], clean_ast(p2))}
  end

  def clean_ast({a1, line1, l1, {a2, line2, l2, l3}}) when is_list(l3) do
    {a1, line1, l1, {a2, line2, l2, Enum.map(l3, &clean_ast/1)}}
  end

  def clean_ast({{a1, line1, nil}, {b1, line2, l1}}) when is_list(l1) do
    {{a1, line1, nil}, {b1, line2, Enum.map(l1, &clean_ast/1)}}
  end

  def clean_ast([do: {:__block__, g1, l1}]) do
    [do: {:__block__, g1, Enum.map(l1, &clean_ast/1)}]
  end

  def clean_ast([do: p1]) do
    [do: clean_ast(p1)]
  end

  def clean_ast([:when, line1, l1]) when is_list(l1) do
    [:when, line1, Enum.map(l1, &clean_ast/1)]
  end

  # The atom can't get the line number
  def clean_ast([__struct__: {:__aliases__, [counter: 0, line: _ln],
                 [:Regex]}, opts: p1, re_pattern: p2, source: p3]) do
    [__struct__: {:__aliases__, [counter: 0, line: 0], [:Regex]},
     opts: p1, re_pattern: p2, source: p3]
  end

  def clean_ast(l1) when is_list(l1) do
    Enum.map(l1, &clean_ast/1)
  end

  def clean_ast({a1, line1, [{a2, line2, [{a3, line3, nil}]}, [do: l1]]}) do
    {a1, line1, [{a2, line2, [{a3, line3, nil}]},
     [do: Enum.map(l1, &clean_ast/1)]]}
  end

  def clean_ast({a1, [line: ln1], [:when, [line: ln2], l1]}) when is_list(l1) do
    {a1, [line: ln1], [:when, [line: ln2], Enum.map(l1, &clean_ast/1)]}
  end

  def clean_ast({a1, [line: ln1], l1}) when is_list(l1) do
    {a1, [line: ln1], Enum.map(l1, &clean_ast/1)}
  end

  def clean_ast(ast) do
    ast
  end

  def find_diff([h1|t1] = l1, [h2|t2] = l2) when is_list(l1) and is_list(l2) do
    unless l1 == l2 do
      IO.inspect("match1")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(h1, h2)
      find_diff(t1, t2)
    end
  end

  def find_diff({:do, {:__block__, _g1, l1}}, {:do, {:__block__, _g2, l2}}) do
    unless l1 == l2 do
      IO.inspect("match2")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff([do: {:__block__, _g1, l1}], [do: {:__block__, _g2, l2}]) do
    unless l1 == l2 do
      IO.inspect("match2")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff({:do, p1}, {:do, p2}) do
    unless p1 == p2 do
      IO.inspect("match3")
      IO.inspect(p1)
      IO.inspect(p2)
    end
  end

  def find_diff([do: p1], [do: p2]) do
    unless p1 == p2 do
      IO.inspect("match3")
      IO.inspect(p1)
      IO.inspect(p2)
    end
  end

  def find_diff({:defmodule, line, [_, l1]}, {:defmodule, line, [_, l2]}) do
    unless l1 == l2 do
      IO.inspect("match4")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff({a, line, [h1|t1] = l1}, {a, line, [h2|t2] = l2})
                when is_list(l1) and is_list(l2) do
    unless l1 == l2 do
      IO.inspect("match5")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(h1, h2)
      find_diff(t1, t2)
    end
  end

  def find_diff([], []) do
  end

  def find_diff(i1, i2) do
    IO.inspect("nothing")
    IO.inspect(i1)
    IO.inspect(i2)
  end
end

ExUnit.start()
