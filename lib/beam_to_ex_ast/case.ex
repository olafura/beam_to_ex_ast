import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Case, {:case, _ln, _param, _body}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:case, ln, param, body}) do
    {:case, [line: ln],
     [Translate.to_elixir(param), [do: Translate.to_elixir(body)]]}
  end
end