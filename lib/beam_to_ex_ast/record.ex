import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Record, {:record, _ln, _name, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:record, ln, name, params}) do
    {:record, [line: ln],
     [clean_atom(name), Translate.to_elixir(params)]}
  end
end
