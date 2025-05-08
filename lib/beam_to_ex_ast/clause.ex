defmodule BeamToExAst.Clause do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:clause, ln, params, guard, body}, opts) do
    opts = Map.update!(opts, :parents, &[:clause | &1])

    case check_params(params) do
      false ->
        case guard do
          [] ->
            {:->, [line: get_line(ln)],
             [Translate.to_elixir(params, opts), def_body_less_filter(body, opts)]}

          [[g]] ->
            {:->, [line: get_line(ln)],
             [
               [
                 {:when, [line: get_line(ln)],
                  [only_one(Translate.to_elixir(params, opts)), Translate.to_elixir(g, opts)]}
               ],
               def_body_less_filter(body, opts)
             ]}
        end

      true ->
        {:&, [line: get_line(ln)], [def_body_less_filter(body, opts)]}
    end
  end
end
