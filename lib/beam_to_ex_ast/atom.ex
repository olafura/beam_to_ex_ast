defmodule BeamToExAst.Atom do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:atom, ln, caller}, %{parents: [:call | _]} = opts) do
    opts = Map.update!(opts, :parents, &[:atom | &1])
    {params, opts} = Map.pop(opts, :call_params)
    {caller, [line: get_line(ln)], Translate.to_elixir(params, opts)}
  end

  def to_elixir({:atom, _ln, a1}, _) do
    a1
  end
end
