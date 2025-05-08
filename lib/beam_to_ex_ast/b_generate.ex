defmodule BeamToExAst.BGenerate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:b_generate, ln, {:bin, ln2, [bin]}, param2}, opts) do
    opts = Map.update!(opts, :parents, &[:b_generate | &1])

    {:<<>>, [line: get_line(ln)],
     [
       {:<-, [line: get_line(ln2)],
        [Translate.to_elixir(bin, opts), Translate.to_elixir(param2, opts)]}
     ]}
  end
end
