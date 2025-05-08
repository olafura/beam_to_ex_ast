defmodule BeamToExAst.If do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:if, ln, params}, opts) do
    opts = Map.update!(opts, :parents, &[:if | &1])
    {:cond, [line: get_line(ln)], [[do: Translate.to_elixir(params, opts)]]}
  end
end
