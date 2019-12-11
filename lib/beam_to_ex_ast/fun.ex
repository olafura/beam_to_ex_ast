import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Fun, {:fun, _ln, _params}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:fun, ln, param}, opts) do
    opts = Map.update!(opts, :parents, &[:fun | &1])
    opts = Map.put(opts, :line, ln)

    case Translate.to_elixir(param, opts) do
      [{:&, line, body}] -> {:&, line, body}
      p1 -> {:fn, [line: ln], p1}
    end
  end
end
