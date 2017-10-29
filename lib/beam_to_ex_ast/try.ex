import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Try, {:try, _ln, _params, _else_params, _catch_rescue_params, _after_params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:try, ln, params, else_params, catch_rescue_params, after_params}, opts) do
    {:try, [line: ln], [
        [
          do: Translate.to_elixir(params, opts),
          # rescue: Translate.to_elixir(rescue_params, opts),
          catch: Translate.to_elixir(catch_rescue_params, opts),
          else: Translate.to_elixir(else_params, opts),
          after: Translate.to_elixir(after_params, opts),
        ]
      ]}
  end
end
