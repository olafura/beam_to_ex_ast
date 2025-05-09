defmodule BeamToExAst.RecordField do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:record_field, _ln, {:atom, _ln2, name}, p2}, opts) do
    opts = Map.update!(opts, :parents, &[:record_field | &1])
    {clean_atom(name, opts), Translate.to_elixir(p2, opts)}
  end
end
