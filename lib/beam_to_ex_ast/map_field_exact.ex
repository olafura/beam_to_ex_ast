defmodule BeamToExAst.MapFieldExact do
  alias BeamToExAst.Translate

  def to_elixir({:map_field_exact, _ln, key, val}, opts) do
    {Translate.to_elixir(key, opts), Translate.to_elixir(val, opts)}
  end
end
