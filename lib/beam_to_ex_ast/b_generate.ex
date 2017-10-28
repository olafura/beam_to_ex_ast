import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.BGenerate, {:b_generate, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:b_generate, ln, {:bin, ln2, [bin]}, param2}) do
    {:<<>>, [line: ln], [{:<-, [line: ln2], [Translate.to_elixir(bin), Translate.to_elixir(param2)]}]}
  end
end
