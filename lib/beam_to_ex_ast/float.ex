import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Float, {:float, _ln, _f1}, for: Translate do
  import BeamToExAst

  def to_elixir({:float, _ln, f1}) do
    f1
  end
end
