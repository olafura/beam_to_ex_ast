import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Clause, {:clause, _ln, _params, _guard, _body}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:clause, ln, params, guard, body}) do
    case check_params(params) do
      false ->
        case guard do
          [] ->
            {:->, [line: ln],
             [Enum.map(params, &convert_param_match/1),
              def_body_less_filter(body)]}
          [[g]] ->
            {:->, [line: ln],
             [[{:when, [line: ln],
               [only_one(Enum.map(params, &convert_param_match/1)),
                Translate.to_elixir(g)]}], def_body_less_filter(body)]}
        end
      true -> {:&, [line: ln], [def_body_less_filter(body)]}
    end
  end
end
