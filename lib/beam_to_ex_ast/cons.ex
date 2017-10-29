import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Cons, {:cons, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:cons, _ln, c1, c2}, opts) do
    case {Translate.to_elixir(c1, opts), Translate.to_elixir(c2, opts)} do
      {cc1, cc2} when is_tuple(cc1) and is_tuple(cc2) ->
        {_, [line: ln2], _} = cc1
        [{:|, [line: ln2], [cc1, cc2]}]
      {cc1, cc2} -> [cc1 | cc2]
    end
  end
end
