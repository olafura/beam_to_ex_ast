defmodule BeamToExAst.MapFieldAssoc do
  alias BeamToExAst.Translate

  def to_elixir({:map_field_assoc, _ln, key, val}, opts) do
    opts = Map.update!(opts, :parents, &[:map_field_assoc | &1])
    {Translate.to_elixir(key, opts), Translate.to_elixir(val, opts)}
  end
end
