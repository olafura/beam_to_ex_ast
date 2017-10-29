import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Clauses, {:clauses, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:clauses, params}, opts) do
    Translate.to_elixir(params, opts)
  end
end
