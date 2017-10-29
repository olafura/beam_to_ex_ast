import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.String, {:string, _ln, _s1}, for: Translate do
  import BeamToExAst

  def to_elixir({:string, _ln, s1}, _) when is_list(s1) do
    List.to_string(s1)
  end
  def to_elixir({:string, _ln, s1}, _) do
    s1
  end
end
