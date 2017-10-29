import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Var, {:var, _ln, _var}, for: Translate do
  import BeamToExAst

  def to_elixir({:var, ln, var}, _) do
    case Atom.to_string(var) do
      <<"_@", rest :: binary>> ->
        {:&, [line: ln], [String.to_integer(rest)]}
      _ ->
        {clean_var(var), [line: ln], nil}
    end
  end
end
