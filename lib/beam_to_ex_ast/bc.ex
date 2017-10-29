import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Bc, {:bc, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  defp uncase(param) when is_list(param) and length(param) == 1 do
    Translate.to_elixir(param)
  end
  defp uncase([param, {:case, _ln, param2, _clauses}]) do
    [Translate.to_elixir(param), Translate.to_elixir(param2)]
  end

  def to_elixir({:bc, ln, param1, param2}) do
    {:for, [line: ln], uncase(param2) ++ [[into: "", do: Translate.to_elixir(param1)]]}
  end
end
