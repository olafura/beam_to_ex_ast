import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Clause, {:clause, _ln, _params, _guard, _body}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:clause, ln, params, guard, body}, opts) do
    case check_params(params) do
      false ->
        case guard do
          [] ->
            {:->, [line: ln],
             [Enum.map(params, &(convert_param_match(&1, opts))),
              def_body_less_filter(body, opts)]}
          [[g]] ->
            {:->, [line: ln],
             [[{:when, [line: ln],
               [only_one(Enum.map(params, &(convert_param_match(&1, opts)))),
                Translate.to_elixir(g, opts)]}], def_body_less_filter(body, opts)]}
        end
      true -> {:&, [line: ln], [def_body_less_filter(body, opts)]}
    end
  end
end
