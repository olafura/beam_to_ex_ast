import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Receive1, {:receive, _ln, _params}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:receive, ln, params}, opts) do
    opts = Map.update!(opts, :parents, &[:receive | &1])
    {:receive, [line: ln], [[do: Translate.to_elixir(params, opts)]]}
  end
end

defimplEx BeamToExAst.Receive2, {:receive, _ln, _params, _period, _after_body}, for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:receive, ln, params, period, after_body}, opts) do
    opts = Map.update!(opts, :parents, &[:receive | &1])

    {:receive, [line: ln],
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
