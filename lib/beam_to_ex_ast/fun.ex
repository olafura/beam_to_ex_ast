defmodule BeamToExAst.Fun do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:fun, ln, {:function, caller, number_of_params}}, _) do
    {:&, [line: get_line(ln)],
     [{:/, [line: get_line(ln)], [{caller, [line: get_line(ln)], nil}, number_of_params]}]}
  end

  def to_elixir({:fun, ln, param}, opts) do
    opts = Map.update!(opts, :parents, &[:fun | &1])

    opts = Map.update!(opts, :parents, &[:fun | &1])

    case Translate.to_elixir(param, opts) do
      [{:&, line, body}] -> {:&, line, body}
      p1 -> {:fn, [line: get_line(ln)], p1}
    end
  end
end
