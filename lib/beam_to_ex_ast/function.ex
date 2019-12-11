import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Function, {:function, _caller, _number_of_params}, for: Translate do
  def to_elixir({:function, caller, number_of_params}, opts) do
    line = Map.get(opts, :line)
    [{:/, [line: line], [{caller, [line: line], nil}, number_of_params]}]
  end
end

defimplEx BeamToExAst.FunctionErl, {:function, _module, _caller, _number_of_params},
  for: Translate do
  alias BeamToExAst.Translate

  def to_elixir({:function, module, caller, number_of_params}, opts) do
    line = Map.get(opts, :line)

    trans_module = Translate.to_elixir(module, opts)
    trans_caller = Translate.to_elixir(caller, opts)
    trans_number_of_params = Translate.to_elixir(number_of_params, opts)

    [
      {:/, [line: line],
       [{{:., [], [trans_module, trans_caller]}, [], []}, trans_number_of_params]}
    ]
  end
end
