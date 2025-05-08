defmodule BeamToExAst.Integer do
  def to_elixir({:integer, _ln, i1}, _) do
    i1
  end
end
