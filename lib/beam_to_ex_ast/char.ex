import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Char, {:char, _ln, _c1}, for: Translate do
  def to_elixir({:char, _ln, c1}, _) do
    c1
  end
end
