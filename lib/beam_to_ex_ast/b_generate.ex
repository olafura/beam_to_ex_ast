import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.BGenerate, {:b_generate, _ln, _param1, _param2}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:b_generate, ln, {:bin, ln2, [bin]}, param2}, opts) do
    opts = Map.update!(opts, :parents, &[:b_generate | &1])

    {:<<>>, [line: ln],
     [{:<-, [line: ln2], [Translate.to_elixir(bin, opts), Translate.to_elixir(param2, opts)]}]}
  end
end
