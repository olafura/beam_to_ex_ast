defmodule BeamToExAstTestUtils do
  def ast_to_erl(ast) do
    e = :elixir.env_for_eval([])
    :elixir.quoted_to_erl(ast, e)
  end

  def clean_ast(ast) do
    Macro.postwalk(ast, fn
      {:|>, _line1, [p1, {c1, line2, nil}]} ->
        {c1, line2, Enum.concat([p1], [])}

      {:|>, _line1, [p1, {c1, line2, p2}]} ->
        {c1, line2, Enum.concat([clean_ast(p1)], clean_ast(p2))}

      {atom, opts, params} when is_list(opts) ->
        {atom, Keyword.delete(opts, :line), params}

      other ->
        other
    end)
  end

  def find_diff([h1 | t1] = l1, [h2 | t2] = l2) when is_list(l1) and is_list(l2) do
    if l1 != l2 do
      IO.inspect("match1")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(h1, h2)
      find_diff(t1, t2)
    end
  end

  def find_diff({:do, {:__block__, _g1, l1}}, {:do, {:__block__, _g2, l2}}) do
    if l1 != l2 do
      IO.inspect("match2")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff([do: {:__block__, _g1, l1}], do: {:__block__, _g2, l2}) do
    if l1 != l2 do
      IO.inspect("match2")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff({:do, p1}, {:do, p2}) do
    if p1 != p2 do
      IO.inspect("match3")
      IO.inspect(p1)
      IO.inspect(p2)
    end
  end

  def find_diff([do: p1], do: p2) do
    if p1 != p2 do
      IO.inspect("match3")
      IO.inspect(p1)
      IO.inspect(p2)
    end
  end

  def find_diff({:defmodule, line, [_, l1]}, {:defmodule, line, [_, l2]}) do
    if l1 != l2 do
      IO.inspect("match4")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff({a, line, [h1 | t1] = l1}, {a, line, [h2 | t2] = l2})
      when is_list(l1) and is_list(l2) do
    if l1 != l2 do
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

ExUnit.configure(exclude: [wip: true, dogfood: true])
ExUnit.start()
