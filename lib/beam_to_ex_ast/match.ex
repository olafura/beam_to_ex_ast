import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Match, {:match, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:match, _ln, {:var, _, _}, {:atom, _, nil}}, _) do
    :filter_this_thing_out_of_the_list_please
  end
  def to_elixir({:match, _ln, {:var, _, v1}, {:var, _, v1}}, _) do
    :filter_this_thing_out_of_the_list_please
  end
  def to_elixir({:match, ln, m1, m2}, opts) do
    opts = Map.update!(opts, :parents, &([:match | &1]))
    {:=, [line: ln], [convert_param_match(m1, opts), Translate.to_elixir(m2, opts)]}
  end
end
