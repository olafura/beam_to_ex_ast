import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.String, {:string, _ln, _s1}, for: Translate do
  import BeamToExAst

  def to_elixir({:string, _ln, s1}) do
    s1
  end
end
