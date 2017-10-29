import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Call, {:call, _ln, _caller, _params}, for: Translate do
  import BeamToExAst

  def to_elixir({:call, _ln, caller, params}, opts) do
    opts = Map.update!(opts, :parents, &([:call | &1]))
    def_caller(caller, params, opts)
  end
end
