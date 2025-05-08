defmodule BeamToExAst.Block do
  def to_elixir({:block, _ln, params}, opts) do
    opts = Map.update!(opts, :parents, &[:block | &1])
    BeamToExAst.def_body(params, opts)
  end
end
