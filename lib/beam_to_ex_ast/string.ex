defmodule BeamToExAst.String do
  def to_elixir({:string, _ln, s1}, %{parents: [:bin_element | _]}) when is_list(s1) do
    List.to_string(s1)
  end

  def to_elixir({:string, _ln, s1}, _opts) when is_list(s1) do
    s1
  end

  def to_elixir({:string, _ln, s1}, _opts) do
    s1
  end
end
