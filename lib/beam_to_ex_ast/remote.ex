import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Remote, {:remote, _ln, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir(
        {:remote, ln, {:atom, _ln, :erlang}, {:atom, ln2, :atom_to_binary}},
        %{parents: [:call | _]} = opts
      ) do
    opts = Map.update!(opts, :parents, &[:remote | &1])
    {params, opts} = Map.pop(opts, :call_params)

    {{:., [line: ln], [{:__aliases__, [line: ln2], [:Atom]}, :to_string]}, [line: ln2],
     List.delete_at(Translate.to_elixir(params, opts), -1)}
  end

  def to_elixir(
        {:remote, ln, {:atom, _ln, :erlang}, {:atom, ln2, :binary_to_atom}},
        %{parents: [:call | _]} = opts
      ) do
    opts = Map.update!(opts, :parents, &[:remote | &1])
    {params, opts} = Map.pop(opts, :call_params)

    {{:., [line: ln], [{:__aliases__, [line: ln2], [:String]}, :to_atom]}, [line: ln2],
     List.delete_at(Translate.to_elixir(params, opts), -1)}
  end

  def to_elixir(
        {:remote, ln, {:atom, _ln, :erlang}, {:atom, ln2, :binary_to_integer}},
        %{parents: [:call | _]} = opts
      ) do
    opts = Map.update!(opts, :parents, &[:remote | &1])
    {params, opts} = Map.pop(opts, :call_params)

    {{:., [line: ln], [{:__aliases__, [line: ln2], [:String]}, :to_integer]}, [line: ln2],
     Translate.to_elixir(params, opts)}
  end

  def to_elixir(
        {:remote, ln, {:atom, _, mod_call}, {:atom, _, caller}},
        %{parents: [:call | _]} = opts
      ) do
    opts = Map.update!(opts, :parents, &[:remote | &1])
    {params, opts} = Map.pop(opts, :call_params)

    case half_clean_atom(mod_call, opts) do
      "erlang" -> {caller, [line: ln], Translate.to_elixir(params, opts)}
      "Kernel" -> {caller, [line: ln], Translate.to_elixir(params, opts)}
      c_mod_call -> get_caller(c_mod_call, ln, caller, params, opts)
    end
  end
end
