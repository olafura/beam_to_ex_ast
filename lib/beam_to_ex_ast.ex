defmodule BeamToExAst do
    def convert(list) do
        {mod_name, rest} = Enum.reduce(list, {"", []}, &do_convert/2)
        case length(rest) do
            1 -> {:defmodule, [line: 1],
            [{:__aliases__, [counter: 0, line: 1], [mod_name]},
             [do: List.first(rest)]]}
            _ -> {:defmodule, [line: 1],
            [{:__aliases__, [counter: 0, line: 1], [mod_name]},
             [do: {:__block__, [], Enum.inverse(rest)}]]}
            
        end
    end

    #_n is number of parameters
    #ln is the line number
    def do_convert({:attribute, _ln, :module, name}, {_, rest}) do
        {clean_atom(name), rest}
    end

    def do_convert({:attribute, _, _, _}, acc) do
        acc
    end

    def do_convert({:function, _, :__info__, _, _}, acc) do
        acc
    end

    def do_convert({:function, ln, name, _n, body}, {mod_name, rest}) do
        case body do
            [{:clause, ln2, _params, _guard, def_body}] ->
                {mod_name, [{:def,
                             [line: ln],
                             [{name, [line: ln2], []}, def_body(def_body)]
                            } | rest]}
            _ -> IO.error(body)
        end
    end

    def def_body(items) do
        case length(items) do
            1 -> [do: def_body_item(List.first(items))]
            _ -> [do: {:__block__, [], Enum.map(items, &def_body_item/1)}]
        end
    end

    def def_body_item({:call, _ln, caller, params}) do
        def_caller(caller, params)
    end

    def def_caller({:remote, ln,{:atom, _, mod_call},
                    {:atom, _, caller}}, params) do
        {{:., [line: ln],
          [{:__aliases__, [counter: 0, line: ln],
            [clean_atom(mod_call)]},
          clean_atom(caller)]}, [line: ln], convert_params(params)}
    end

    def caller({:atom, ln, caller}, params) do
        {caller, [line: ln], convert_params(params)}
    end

    def convert_params(params) do
        Enum.map(params, &convert_param/1)
    end

    def convert_param({:var, ln, var}) do
        {var, [line: ln], nil}
    end

    def convert_param({:bin, _ln, elements}) do
        convert_bin(List.first(elements))
    end

    def convert_bin({:bin_element, ln, {:string, ln, str}, _, _}) do
        to_string(str)
    end

    def clean_atom(a1) do
        s1 = Atom.to_string(a1)
        String.to_atom(String.replace(s1, "Elixir.", ""))
    end
end
