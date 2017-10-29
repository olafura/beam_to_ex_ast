import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Bin, {:bin, _ln, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:bin, _ln, []}, _) do
    ""
  end
  def to_elixir({:bin, ln, elements}, opts) do
    elements
    |> Translate.to_elixir(opts)
    |> Enum.filter(fn
      {:atom, _, nil} -> false
      _ -> true
    end)
    |> case do
      [bin] when is_binary(bin) ->
        bin
      bins when length(bins) === 2 -> {:<>, [line: ln], bins}
      bins ->
        case Enum.reduce(bins, false, &check_bins/2) do
          true ->
            {:<<>>, [line: ln], bins}
          false ->
            bins
        end
    end
  end
end
