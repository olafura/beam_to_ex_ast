import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.List, list when is_list(list), for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir(params) do
    Enum.map(params, &Translate.to_elixir/1)
  end
end
