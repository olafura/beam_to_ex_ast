defmodule BeamToExAst.Case do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:case, ln, param, body}, opts) do
    opts = Map.update!(opts, :parents, &[:case | &1])

    {:case, [line: get_line(ln)],
     [Translate.to_elixir(param, opts), [do: Translate.to_elixir(body, opts)]]}
  end
end
