import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Bin, {:bin, _ln, _params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:bin, _ln, []}) do
    ""
  end
  def to_elixir({:bin, ln, elements}) do
    case Translate.to_elixir(elements) do
      bins when length(bins) === 1 ->
        List.first(bins)
      bins ->
        case Enum.reduce(bins, false, &check_bins/2) do
          true ->
            {:<>, [line: ln], bins}
          false ->
            bins
        end
    end
  end
end
