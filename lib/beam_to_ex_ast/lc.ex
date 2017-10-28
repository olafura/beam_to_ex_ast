import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Lc, {:lc, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:lc, ln, param1, [param2]}) do
    {:for, [line: ln], [Translate.to_elixir(param2), Translate.to_elixir(param1)]}
  end
end
