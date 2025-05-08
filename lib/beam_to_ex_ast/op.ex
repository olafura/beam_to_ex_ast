defmodule BeamToExAst.Op1 do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:op, ln, op1, p1}, opts) do
    opts = Map.update!(opts, :parents, &[:op | &1])
    {clean_op(op1), [line: get_line(ln)], [Translate.to_elixir(p1, opts)]}
  end
end

defmodule BeamToExAst.Op2 do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:op, ln, :!, p1, p2}, opts) do
    {:send, [line: get_line(ln)], [Translate.to_elixir(p1, opts), Translate.to_elixir(p2, opts)]}
  end

  def to_elixir({:op, ln, op1, p1, p2}, opts) do
    opts = Map.update!(opts, :parents, &[:op | &1])

    {clean_op(op1), [line: get_line(ln)],
     [insert_line_number(Translate.to_elixir(p1, opts), ln), Translate.to_elixir(p2, opts)]}
  end
end
