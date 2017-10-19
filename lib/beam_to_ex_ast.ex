defmodule BeamToExAst do
  alias BeamToExAst.Translate

  def convert(list) do
    {mod_name, rest} = Enum.reduce(list, {"", []}, &do_convert/2)
    case length(rest) do
      1 -> {:defmodule, [line: 1],
            [{:__aliases__, [counter: 0, line: 1], [mod_name]},
            [do: List.first(rest)]]}
      _ -> {:defmodule, [line: 1],
            [{:__aliases__, [counter: 0, line: 1], [mod_name]},
            [do: {:__block__, [], Enum.sort(rest, &sort_fun/2)}]]}
    end
  end

  def sort_fun({:def, [line: lna], _}, {:def, [line: lnb], _}) do
    lna < lnb
  end

  # _n is number of parameters
  # ln is the line number
  def do_convert({:attribute, _ln, :module, name}, {_, rest}) do
   {clean_module(name), rest}
  end
  def do_convert({:attribute, _, _, _}, acc) do
    acc
  end
  def do_convert({:function, _, :__info__, _, _}, acc) do
    acc
  end
  def do_convert({:function, _ln, name, _n, body}, {mod_name, rest}) do
    {mod_name, Enum.concat(Enum.map(body, fn
      {:clause, ln2, params, guard, body_def} ->
        case guard do
          [] ->
            {:def,
             [line: ln2],
             [{name,
               [line: ln2],
               Translate.to_elixir(params)
              },
              def_body(body_def)
             ]
            }
          [[g]] -> {:def, [line: ln2],
                    [{:when, [line: ln2],
                      [{name, [line: ln2], Translate.to_elixir(params)},
                        Translate.to_elixir(g)]}, def_body(body_def)]}
          [g1, g2] -> {:def, [line: ln2],
                        [{:when, [line: ln2],
                          [{name, [line: ln2], Translate.to_elixir(params)},
                          {:and, [], [Translate.to_elixir(List.first(g1)), Translate.to_elixir(List.first(g2))]}]}, def_body(body_def)]}

        end
      _ -> IO.inspect(body)
    end), rest)}
  end

  def do_convert({:eof, _ln}, acc) do
    acc
  end

  def def_body(items) do
    case length(items) do
      1 -> [do: Translate.to_elixir(List.first(items))]
      _ -> [do: {:__block__, [], Enum.map(items, &Translate.to_elixir/1)}]
    end
  end

  def def_body_less(items) do
    case length(items) do
      1 -> Translate.to_elixir(List.first(items))
      _ -> {:__block__, [], Translate.to_elixir(items)}
    end
  end

  def def_body_less_filter(items) do
    items2 = items
    |> Translate.to_elixir()
    |> Enum.filter(&filter_empty/1)
    case length(items2) do
      1 -> List.first(items2)
      _ -> {:__block__, [], items2}
    end
  end

  def get_caller(c_mod_call, ln, caller, params) do
    case String.match?(c_mod_call, ~r"^[A-Z]") do
      true -> {{:., [line: ln],
                [{:__aliases__, [counter: 0, line: ln],
                 [String.to_atom(c_mod_call)]}, clean_atom(caller)]},
               [line: ln], Translate.to_elixir(params)}
      false -> {{:., [line: ln],
                 [String.to_atom(c_mod_call), clean_atom(caller)]},
                [line: ln], Translate.to_elixir(params)}
    end
  end

  def def_caller({:remote, ln, {:atom, _ln, :erlang},
                  {:atom, ln2, :atom_to_binary}}, params) do
    {{:., [line: ln],
      [{:__aliases__, [counter: 0, line: ln2],[:Atom]}, :to_string]},
     [line: ln2], List.delete_at(Translate.to_elixir(params), -1)}
  end

  def def_caller({:remote, ln, {:atom, _ln, :erlang},
                  {:atom, ln2, :binary_to_atom}}, params) do
    {{:., [line: ln],
      [{:__aliases__, [counter: 0, line: ln2], [:String]}, :to_atom]},
     [line: ln2], List.delete_at(Translate.to_elixir(params), -1)}
  end

  def def_caller({:remote, ln, {:atom, _ln, :erlang},
                  {:atom, ln2, :binary_to_integer}}, params) do
    {{:., [line: ln],
      [{:__aliases__, [counter: 0, line: ln2], [:String]}, :to_integer]},
     [line: ln2], Translate.to_elixir(params)}
  end

  def def_caller({:remote, ln,{:atom, _, mod_call},
                 {:atom, _, caller}}, params) do
    case half_clean_atom(mod_call) do
      "erlang" -> {caller, [line: ln],  Translate.to_elixir(params)}
      "Kernel" -> {caller, [line: ln],  Translate.to_elixir(params)}
      c_mod_call -> get_caller(c_mod_call, ln, caller, params)
    end
  end

  def def_caller({:atom, ln, caller}, params) do
    {caller, [line: ln], Translate.to_elixir(params)}
  end

  def def_caller({:var, ln, caller}, params) do
    {{:., [line: ln],
      [{clean_var(caller), [line: ln], nil}]},
     [line: ln], Translate.to_elixir(params)}
  end

  def remove_tuples(l1) when is_list(l1) do
    Enum.map(l1, &remove_tuple/1)
  end

  def remove_tuples(rest) do
    rest
  end

  def remove_tuple({:{}, [line: _ln], params}) do
    params
  end

  def remove_tuple(params) do
    params
  end

  def only_one(l1) do
    case length(l1) do
      1 -> List.first(l1)
      _ -> l1
    end
  end

  def convert_param_match({:bin, ln, elements}) do
    case Enum.map(elements, &convert_bin_match/1) do
      bins when length(bins) === 1 -> List.first(bins)
      bins ->
        case Enum.reduce(bins, false, &check_bins/2) do
          true -> {:<<>>, [line: ln], bins}
          false -> bins
        end
    end
  end
  def convert_param_match(i1) do
    Translate.to_elixir(i1)
  end

  def insert_line_number({:&, [line: 0], number}, ln) do
    {:&, [line: ln], number}
  end

  def insert_line_number(var, _ln) do
    var
  end

  def check_params(params) do
    Enum.reduce(params, false, fn
      ({:var, _ln, var}, acc) ->
        case Atom.to_string(var) do
          <<"_@", _rest :: binary>> -> true
          _ -> acc
        end
      (_, acc) -> acc
    end)
  end

  def check_bins(s1, acc) when is_binary(s1) do
    acc
  end

  def check_bins(_, _acc) do
    true
  end

  # I need to explore this more with size and other conditions
  def convert_bin_match({:bin_element, _ln, {:var, ln2, v1}, _, [:integer]}) do
    Translate.to_elixir({:var, ln2, v1})
  end
  def convert_bin_match({:bin_element, ln, {:var, ln2, v1}, _, [type]}) do
    {:::, [line: ln], [Translate.to_elixir({:var, ln2, v1}), {type, [line: ln], nil}]}
  end
  def convert_bin_match(b1) do
    Translate.to_elixir(b1)
  end

  def clean_op(op1) do
    op1
    |> Atom.to_string
    |> case do
      "=:=" -> "==="
      "=/=" -> "!=="
      "/=" -> "!="
      "=<" -> "<="
      "andalso" -> "and"
      s1 -> s1
    end
    |> String.to_atom
  end

  def clean_module(a1) do
    s1 = a1
    |> Atom.to_string
    |> String.replace("Elixir.", "")

    s1
    |> String.match?(~r"^[A-Z]")
    |> case do
      true -> s1
      false -> Macro.camelize(s1)
    end
    |> String.to_atom
  end

  def clean_atom(a1) do
    a1
    |> Atom.to_string
    |> String.replace("Elixir.", "")
    |> String.to_atom
  end

  def half_clean_atom(a1) do
    a1
    |> Atom.to_string
    |> String.replace("Elixir.", "")
  end

  def clean_var(v1) do
    v1
    |> Atom.to_string
    |> String.replace(~r"@\d+", "")
    |> String.to_atom
  end

  def filter_empty(:filter_this_thing_out_of_the_list_please) do
    false
  end

  def filter_empty(_) do
    true
  end
end
