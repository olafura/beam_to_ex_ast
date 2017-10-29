import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Atom, {:atom, _ln, _a1} , for: Translate do
  import BeamToExAst

  def to_elixir({:atom, _ln, a1}, _) do
    a1
  end
end
