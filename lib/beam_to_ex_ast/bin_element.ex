import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.BinElement, {:bin_element, _ln, _block, _, _}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:bin_element, _ln, block, {:integer, _ln2, i}, _}) do
    {:::, [], [Translate.to_elixir(block), i]}
  end
  def to_elixir({:bin_element, _ln, block, _, _}) do
    Translate.to_elixir(block)
  end
end
