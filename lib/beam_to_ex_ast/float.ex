import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Float, {:float, _ln, _f1}, for: Translate do
  def to_elixir({:float, _ln, f1}, _) do
    f1
  end
end
