import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Try, {:try, _ln, _params, _else_params, _catch_rescue_params, _after_params}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:try, ln, params, else_params, catch_rescue_params, after_params}) do
    {:try, [line: ln], [
        [
          do: Translate.to_elixir(params),
          # rescue: Translate.to_elixir(rescue_params),
          catch: Translate.to_elixir(catch_rescue_params),
          else: Translate.to_elixir(else_params),
          after: Translate.to_elixir(after_params),
        ]
      ]}
  end
end
