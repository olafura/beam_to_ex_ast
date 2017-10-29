import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Tuple, {:tuple, _ln, _items}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:tuple, ln, [{:atom, _ln2, a1}, {:atom, _ln3, a2}]}, _) do
    # Need the correct line number to dogfood
    {a1, {:__aliases__, [counter: 0, line: ln], [clean_atom(a2)]}}
  end
  def to_elixir({:tuple, _ln, [{:atom, _ln2, a1}, p2]}, opts) do
    {a1, Translate.to_elixir(p2, opts)}
  end
  def to_elixir({:tuple, _ln, items}, opts) when length(items) === 2 do
    {Translate.to_elixir(List.first(items), opts), Translate.to_elixir(List.last(items), opts)}
  end
  def to_elixir({:tuple, ln, items}, opts) do
    {:{}, [line: ln], Translate.to_elixir(items, opts)}
  end
end
