import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Bc, {:bc, _ln, _param1, _param2}, for: Translate do
  alias BeamToExAst.Translate

  defp uncase(param, opts) when is_list(param) and length(param) == 1 do
    Translate.to_elixir(param, opts)
  end

  defp uncase([param, {:case, _ln, param2, _clauses}], opts) do
    [Translate.to_elixir(param, opts), Translate.to_elixir(param2, opts)]
  end

  def to_elixir({:bc, ln, param1, param2}, opts) do
    opts = Map.update!(opts, :parents, &[:bc | &1])

    {:for, [line: ln],
     uncase(param2, opts) ++ [[into: "", do: Translate.to_elixir(param1, opts)]]}
  end
end
