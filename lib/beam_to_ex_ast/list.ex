import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.List, params when is_list(params), for: Translate do
  alias BeamToExAst.Translate

  def to_elixir(params, opts) do
    Enum.map(params, &(Translate.to_elixir(&1, opts)))
  end
end
