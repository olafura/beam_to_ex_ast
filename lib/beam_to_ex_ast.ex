defmodule BeamToExAst do
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
               convert_params(params)
              },
              def_body(body_def)
             ]
            }
          [[g]] -> {:def, [line: ln2],
                    [{:when, [line: ln2],
                      [{name, [line: ln2], convert_params(params)},
                        convert_param(g)]}, def_body(body_def)]}
        end
      _ -> IO.inspect(body)
    end), rest)}
  end

  def do_convert({:eof, _ln}, acc) do
    acc
  end

  def def_body(items) do
    case length(items) do
      1 -> [do: convert_param(List.first(items))]
      _ -> [do: {:__block__, [], Enum.map(items, &convert_param/1)}]
    end
  end

  def def_body_less(items) do
    case length(items) do
      1 -> convert_param(List.first(items))
      _ -> {:__block__, [], Enum.map(items, &convert_param/1)}
    end
  end

  def def_body_less_filter(items) do
    items2 = items
    |> Enum.map(&convert_param/1)
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
               [line: ln], convert_params(params)}
      false -> {{:., [line: ln],
                 [String.to_atom(c_mod_call), clean_atom(caller)]},
                [line: ln], convert_params(params)}
    end
  end

  def def_caller({:remote, ln, {:atom, _ln, :erlang},
                  {:atom, ln2, :atom_to_binary}}, params) do
    {{:., [line: ln],
      [{:__aliases__, [counter: 0, line: ln2],[:Atom]}, :to_string]},
     [line: ln2], List.delete_at(convert_params(params), -1)}
  end

  def def_caller({:remote, ln, {:atom, _ln, :erlang},
                  {:atom, ln2, :binary_to_atom}}, params) do
    {{:., [line: ln],
      [{:__aliases__, [counter: 0, line: ln2], [:String]}, :to_atom]},
     [line: ln2], List.delete_at(convert_params(params), -1)}
  end

  def def_caller({:remote, ln, {:atom, _ln, :erlang},
                  {:atom, ln2, :binary_to_integer}}, params) do
    {{:., [line: ln],
      [{:__aliases__, [counter: 0, line: ln2], [:String]}, :to_integer]},
     [line: ln2], convert_params(params)}
  end

  def def_caller({:remote, ln,{:atom, _, mod_call},
                 {:atom, _, caller}}, params) do
    case half_clean_atom(mod_call) do
      "erlang" -> {caller, [line: ln],  convert_params(params)}
      "Kernel" -> {caller, [line: ln],  convert_params(params)}
      c_mod_call -> get_caller(c_mod_call, ln, caller, params)
    end
  end

  def def_caller({:atom, ln, caller}, params) do
    {caller, [line: ln], convert_params(params)}
  end

  def def_caller({:var, ln, caller}, params) do
    {{:., [line: ln],
      [{clean_var(caller), [line: ln], nil}]},
     [line: ln], convert_params(params)}
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

  def convert_params(params) do
    Enum.map(params, &convert_param/1)
  end

  def convert_param({:call, _ln, caller, params}) do
    def_caller(caller, params)
  end

  def convert_param({:match, _ln, {:var, _, _}, {:atom, _, nil}}) do
    :filter_this_thing_out_of_the_list_please
  end

  def convert_param({:match, _ln, {:var, _, v1}, {:var, _, v1}}) do
    :filter_this_thing_out_of_the_list_please
  end

  def convert_param({:match, ln, m1, m2}) do
    {:=, [line: ln], [convert_param_match(m1), convert_param(m2)]}
  end

  def convert_param({:var, ln, var}) do
    case Atom.to_string(var) do
      <<"_@", rest :: binary>> ->
        {:&, [line: ln], [String.to_integer(rest)]}
      _ ->
        {clean_var(var), [line: ln], nil}
    end
  end

  def convert_param({:bin, _ln, []}) do
    ""
  end

  def convert_param({:bin, ln, elements}) do
    case Enum.map(elements, &convert_bin/1) do
      bins when length(bins) === 1 -> List.first(bins)
      bins ->
        case Enum.reduce(bins, false, &check_bins/2) do
          true -> {:<>, [line: ln], bins}
          false -> bins
        end
    end
  end

  def convert_param({:string, _ln, s1}) do
    s1
  end

  def convert_param({:integer, _ln, i1}) do
    i1
  end

  def convert_param({:float, _ln, f1}) do
    f1
  end

  def convert_param({:atom, _ln, a1}) do
    a1
  end

  def convert_param({:cons, _ln, c1, c2}) do
    case {convert_param(c1), convert_param(c2)} do
      {cc1, cc2} when is_tuple(cc1) and is_tuple(cc2) ->
        {_, [line: ln2], _} = cc1
        [{:|, [line: ln2], [cc1, cc2]}]
      {cc1, cc2} -> [cc1 | cc2]
    end
  end

  def convert_param({:tuple, ln, [{:atom, _ln2, a1}, {:atom, _ln3, a2}]}) do
    # Need the correct line number to dogfood
    {a1, {:__aliases__, [counter: 0, line: ln], [clean_atom(a2)]}}
  end

  def convert_param({:tuple, _ln, [{:atom, _ln2, a1}, p2]}) do
    {a1, convert_param(p2)}
  end

  def convert_param({:tuple, _ln, items}) when length(items) === 2 do
    {convert_param(List.first(items)), convert_param(List.last(items))}
  end

  def convert_param({:tuple, ln, items}) do
    {:{}, [line: ln], Enum.map(items, &convert_param/1)}
  end

  def convert_param({:map, ln, items}) do
    case Enum.map(items, &convert_param/1) do
      [__struct__: Regex,
        opts: "",
        re_pattern: {:{}, [line: ln2], [:re_pattern, 0, 0, 0, _]},
        re_version: _,
        source: b1] ->
          {:sigil_r, [line: ln2], [{:<<>>, [line: ln2], [b1]}, []]}
      p1 -> {:%{}, [line: ln], p1}
    end
  end

  def convert_param({:map_field_assoc, _ln, key, val}) do
    {convert_param(key), convert_param(val)}
  end

  def convert_param({:op, ln, op1, p1}) do
    {clean_op(op1), [line: ln], [convert_param(p1)]}
  end

  def convert_param({:op, ln, op1, p1, p2}) do
    {clean_op(op1), [line: ln],
     [insert_line_number(convert_param(p1), ln), convert_param(p2)]}
  end

  def convert_param({:fun, ln, {:function, caller, number_of_params}}) do
    {:&, [line: ln],
     [{:/, [line: ln], [{caller, [line: ln], nil}, number_of_params]}]}
  end

  def convert_param({:fun, ln, param}) do
    case convert_param(param) do
      [{:&, line, body}] -> {:&, line, body}
      p1 -> {:fn, [line: ln], p1}
    end
  end

  def convert_param({:case, ln, param, body}) do
    {:case, [line: ln],
     [convert_param(param), [do: Enum.map(body, &convert_param/1)]]}
  end

  def convert_param({:clauses, params}) do
    Enum.map(params, &convert_param/1)
  end

  def convert_param({:clause, ln, params, guard, body}) do
    case check_params(params) do
      false ->
        case guard do
          [] ->
            {:->, [line: ln],
             [Enum.map(params, &convert_param_match/1),
              def_body_less_filter(body)]}
          [[g]] ->
            {:->, [line: ln],
             [[{:when, [line: ln],
               [only_one(Enum.map(params, &convert_param_match/1)),
                convert_param(g)]}], def_body_less_filter(body)]}
        end
      true -> {:&, [line: ln], [def_body_less_filter(body)]}
    end
  end

  def convert_param({:record, ln, name, params}) do
    {:record, [line: ln],
     [clean_atom(name), Enum.map(params, &convert_param/1)]}
  end

  def convert_param({:record_field, _ln, {:atom, _ln2, name}, p2}) do
    {clean_atom(name), convert_param(p2)}
  end

  def convert_param({nil, _ln}) do
    []
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
    convert_param(i1)
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

  def convert_bin({:bin_element, _ln, {:string, _ln2, str}, _, _}) do
    List.to_string(str)
  end

  def convert_bin({:bin_element, _ln, {:var, ln2, v1}, _, [_type]}) do
    convert_param({:var, ln2, v1})
  end

  def convert_bin({:bin_element, _ln, {:var, ln2, v1}, _, :default}) do
    convert_param({:var, ln2, v1})
  end

  def convert_bin(nil) do
    []
  end

  # I need to explore this more with size and other conditions
  def convert_bin_match({:bin_element, _ln, {:var, ln2, v1}, _, [:integer]}) do
    convert_param({:var, ln2, v1})
  end
  def convert_bin_match({:bin_element, ln, {:var, ln2, v1}, _, [type]}) do
    {:::, [line: ln], [convert_param({:var, ln2, v1}), {type, [line: ln], nil}]}
  end
  def convert_bin_match(b1) do
    convert_bin(b1)
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
