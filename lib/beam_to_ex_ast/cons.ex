import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Cons, {:cons, _ln, _param1, _param2}, for: Translate do
  alias BeamToExAst.Translate

  defp get_line_number({atom, [line: ln], l1}) when is_atom(atom) and is_list(l1) do
    ln
  end

  defp get_line_number({atom, [line: ln], atom2}) when is_atom(atom) and is_atom(atom2) do
    ln
  end

  defp get_line_number(other) do
    get_line_number(elem(other, 0))
  end

  def to_elixir({:cons, _ln, c1, c2}, opts) do
    opts = Map.update!(opts, :parents, &[:cons | &1])

    case {Translate.to_elixir(c1, opts), Translate.to_elixir(c2, opts)} do
      {cc1, cc2} when is_tuple(cc1) and is_tuple(cc2) ->
        ln2 = get_line_number(cc1)
        [{:|, [line: ln2], [cc1, cc2]}]

      {cc1, cc2} ->
        [cc1 | cc2]
    end
  end
end
