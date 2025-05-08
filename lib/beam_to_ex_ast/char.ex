defmodule BeamToExAst.Char do
  def to_elixir({:char, _ln, c1}, _) do
    c1
  end
end
