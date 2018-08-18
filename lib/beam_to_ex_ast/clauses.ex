import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Clauses, {:clauses, _params}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:clauses, params}, opts) do
    opts = Map.update!(opts, :parents, &[:clauses | &1])
    Translate.to_elixir(params, opts)
  end
end
