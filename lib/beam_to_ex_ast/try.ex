defmodule BeamToExAst.Try do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:try, ln, params, else_params, catch_rescue_params, after_params}, opts) do
    opts = Map.update!(opts, :parents, &[:try | &1])

    {:try, [line: get_line(ln)],
     [
       [
         do: Translate.to_elixir(params, opts),
         # rescue: Translate.to_elixir(rescue_params, opts),
         catch: Translate.to_elixir(catch_rescue_params, opts),
         else: Translate.to_elixir(else_params, opts),
         after: Translate.to_elixir(after_params, opts)
       ]
     ]}
  end
end
