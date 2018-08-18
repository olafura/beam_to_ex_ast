import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Var, {:var, _ln, _var}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:var, ln, caller}, %{parents: [:call | _]} = opts) do
    opts = Map.update!(opts, :parents, &([:var | &1]))
    {params, opts} = Map.pop(opts, :call_params)
    {{:., [line: ln],
      [{clean_var(caller, opts), [line: ln], nil}]},
     [line: ln], Translate.to_elixir(params, opts)}
  end
  def to_elixir({:var, ln, var}, opts) do
    case Atom.to_string(var) do
      <<"_@", rest :: binary>> ->
        with {number, ""} <- Integer.parse(rest) do
          {:&, [line: ln], [number]}
        else
          :error ->
            {:&, [line: ln], [rest]}
        end
      <<"__@", rest :: binary>> ->
        with {number, ""} <- Integer.parse(rest) do
          {:&, [line: ln], [number]}
        else
          :error ->
            {:&, [line: ln], [rest]}
        end
      _ ->
        {clean_var(var, opts), [line: ln], nil}
    end
  end
end
