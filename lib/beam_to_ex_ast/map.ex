defmodule BeamToExAst.Map do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:map, ln, items}, opts) do
    opts = Map.update!(opts, :parents, &[:map | &1])

    case Translate.to_elixir(items, opts) do
      [
        __struct__: Regex,
        opts: "",
        re_pattern: {:{}, [line: ln2], [:re_pattern, 0, 0, 0, _]},
        re_version: _,
        source: b1
      ] ->
        {:sigil_r, [line: get_line(ln)], [{:<<>>, [line: get_line(ln2)], [b1]}, []]}

      p1 ->
        {:%{}, [line: get_line(ln)], p1}
    end
  end
end
