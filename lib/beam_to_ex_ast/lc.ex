import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Lc, {:lc, _ln, _param1, _param2}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:lc, ln, param1, [param2]}, opts) do
    opts = Map.update!(opts, :parents, &([:lc | &1]))
    {:for, [line: ln], [Translate.to_elixir(param2, opts), Translate.to_elixir(param1, opts)]}
  end
end
