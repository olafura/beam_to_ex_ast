defmodule BeamToExAst.Var do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:var, ln, caller}, %{parents: [:call | _]} = opts) do
    opts = Map.update!(opts, :parents, &[:var | &1])
    {params, opts} = Map.pop(opts, :call_params)

    {{:., [line: get_line(ln)], [{clean_var(caller, opts), [line: get_line(ln)], nil}]},
     [line: get_line(ln)], Translate.to_elixir(params, opts)}
  end

  def to_elixir({:var, ln, var}, opts) do
    case Atom.to_string(var) do
      <<"_@", rest::binary>> ->
        capture(ln, rest)

      <<"__@", rest::binary>> ->
        capture(ln, rest)

      <<"_capture@", rest::binary>> ->
        capture(ln, rest)

      _ ->
        {clean_var(var, opts), [line: get_line(ln)], nil}
    end
  end

  defp capture(ln, rest) do
    case Integer.parse(rest) do
      {number, ""} ->
        {:&, [line: get_line(ln)], [number]}
      :error ->
        {:&, [line: get_line(ln)], [rest]}
    end
  end
end
