defmodule BeamToExAst.Receive1 do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:receive, ln, params}, opts) do
    opts = Map.update!(opts, :parents, &[:receive | &1])
    {:receive, [line: get_line(ln)], [[do: Translate.to_elixir(params, opts)]]}
  end
end

defmodule BeamToExAst.Receive2 do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:receive, ln, params, period, after_body}, opts) do
    opts = Map.update!(opts, :parents, &[:receive | &1])

    {:receive, [line: get_line(ln)],
     [
       [
         do: Translate.to_elixir(params, opts),
         after: [
           {:->, [],
            [[Translate.to_elixir(period, opts)] | Translate.to_elixir(after_body, opts)]}
         ]
       ]
     ]}
  end
end
