defmodule BeamToExAst.Record do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:record, ln, name, params}, opts) do
    opts = Map.update!(opts, :parents, &[:record | &1])
    {:record, [line: get_line(ln)], [clean_atom(name, opts), Translate.to_elixir(params, opts)]}
  end
end
