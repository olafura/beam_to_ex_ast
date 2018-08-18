import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Integer, {:integer, _ln, _i1}, for: Translate do
  def to_elixir({:integer, _ln, i1}, _) do
    i1
  end
end
