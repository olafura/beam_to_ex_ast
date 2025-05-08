defmodule BeamToExAst.Nil do
  def to_elixir({nil, _ln}, _) do
    []
  end
end
