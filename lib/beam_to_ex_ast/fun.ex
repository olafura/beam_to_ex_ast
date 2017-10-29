import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Fun, {:fun, _ln, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:fun, ln, {:function, caller, number_of_params}}, _) do
    {:&, [line: ln],
     [{:/, [line: ln], [{caller, [line: ln], nil}, number_of_params]}]}
  end
  def to_elixir({:fun, ln, param}, opts) do
    case Translate.to_elixir(param, opts) do
      [{:&, line, body}] -> {:&, line, body}
      p1 -> {:fn, [line: ln], p1}
    end
  end
end
