import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.MapFieldAssoc, {:map_field_assoc, _ln, _key, _val}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:map_field_assoc, _ln, key, val}) do
    {Translate.to_elixir(key), Translate.to_elixir(val)}
  end
end
