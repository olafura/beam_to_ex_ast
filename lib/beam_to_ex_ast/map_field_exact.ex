defmodule BeamToExAst.MapFieldExact do
  # This is a performace enhancing feature in the compiled code
  def to_elixir({:map_field_exact, _ln, _key, _val}, _) do
    nil
  end
end
