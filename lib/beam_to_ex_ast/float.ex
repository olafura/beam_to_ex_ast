defmodule BeamToExAst.Float do
  def to_elixir({:float, _ln, f1}, _) do
    f1
  end
end
