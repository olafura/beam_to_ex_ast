import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Nil, {nil, _ln}, for: Translate do
  def to_elixir({nil, _ln}, _) do
    []
  end
end
