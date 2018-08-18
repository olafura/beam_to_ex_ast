import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.BinElement, {:bin_element, _ln, _block, _, _}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:bin_element, _ln, {:var, ln2, v1}, _, [:integer]}, %{parents: [:bin, :match | _]} = opts) do
    opts = Map.update!(opts, :parents, &([:bin_element | &1]))
    Translate.to_elixir({:var, ln2, v1}, opts)
  end
  def to_elixir({:bin_element, ln, {:var, ln2, v1}, _, [type]}, %{parents: [:bin, :match | _]} = opts) do
    opts = Map.update!(opts, :parents, &([:bin_element | &1]))
    {:::, [line: ln], [Translate.to_elixir({:var, ln2, v1}, opts), {type, [line: ln], nil}]}
  end
  def to_elixir({:bin_element, _ln, block, {:integer, _ln2, i}, _}, opts) do
    opts = Map.update!(opts, :parents, &([:bin_element | &1]))
    {:::, [], [Translate.to_elixir(block, opts), i]}
  end
  def to_elixir({:bin_element, _ln, block, _, _}, opts) do
    opts = Map.update!(opts, :parents, &([:bin_element | &1]))
    Translate.to_elixir(block, opts)
  end
end
