import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.RecordField, {:record_field, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:record_field, _ln, {:atom, _ln2, name}, p2}) do
    {clean_atom(name), Translate.to_elixir(p2)}
  end
end