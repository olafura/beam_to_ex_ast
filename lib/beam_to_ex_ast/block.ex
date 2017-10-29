import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Block, {:block, _ln, _param}, for: Translate do
  import BeamToExAst

  def to_elixir({:block, _ln, params}, opts) do
    opts = Map.update!(opts, :parents, &([:block | &1]))
    BeamToExAst.def_body(params, opts)
  end
end
