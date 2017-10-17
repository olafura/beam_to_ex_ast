import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.If, {:if, _ln, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:if, ln, params}) do
    {:cond, [line: ln],
     [[do: Translate.to_elixir(params)]]}
  end
end
