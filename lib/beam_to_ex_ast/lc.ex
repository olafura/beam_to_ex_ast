defmodule BeamToExAst.Lc do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:lc, ln, param1, [param2]}, opts) do
    opts = Map.update!(opts, :parents, &[:lc | &1])

    {:for, [line: get_line(ln)],
     [Translate.to_elixir(param2, opts), Translate.to_elixir(param1, opts)]}
  end
end
