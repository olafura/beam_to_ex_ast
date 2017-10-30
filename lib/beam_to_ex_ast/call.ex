import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Call, {:call, _ln, _caller, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:call, _ln, caller, params}, opts) do
    opts = Map.update!(opts, :parents, &([:call | &1]))
    opts = Map.put(opts, :call_params, params)
    Translate.to_elixir(caller, opts)
  end
end
