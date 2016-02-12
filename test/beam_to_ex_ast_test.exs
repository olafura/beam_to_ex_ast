defmodule BeamToExAstTest do
  use ExUnit.Case
  doctest BeamToExAst
  ExUnit.configure(exclude: [wip: true])

  def clean_ast({:defmodule, line1, [c1, p1]}) do
    {:defmodule, line1, [c1, clean_ast(p1)]}
  end

  def clean_ast({:def, line1, l1}) do
    {:def, line1, Enum.map(l1, &clean_ast/1)}
  end

  # I can't know if it was a pipe or not
  def clean_ast({:|>, _line1, [p1, {c1, line2, nil}]}) do
    {c1, line2, Enum.concat([p1], [])}
  end

  def clean_ast({:|>, _line1, [p1, {c1, line2, p2}]}) do
    {c1, line2, Enum.concat([clean_ast(p1)], clean_ast(p2))}
  end

  def clean_ast({a1, line1, l1, {a2, line2, l2, l3}}) when is_list(l3) do
    {a1, line1, l1, {a2, line2, l2, Enum.map(l3, &clean_ast/1)}}
  end

  def clean_ast({{a1, line1, nil}, {b1, line2, l1}}) when is_list(l1) do
    {{a1, line1, nil}, {b1, line2, Enum.map(l1, &clean_ast/1)}}
  end

  def clean_ast([do: {:__block__, g1, l1}]) do
    [do: {:__block__, g1, Enum.map(l1, &clean_ast/1)}]
  end

  def clean_ast([do: p1]) do
    [do: clean_ast(p1)]
  end

  def clean_ast([:when, line1, l1]) when is_list(l1) do
    [:when, line1, Enum.map(l1, &clean_ast/1)]
  end

  # The atom can't get the line number
  def clean_ast([__struct__: {:__aliases__, [counter: 0, line: _ln],
                 [:Regex]}, opts: p1, re_pattern: p2, source: p3]) do
    [__struct__: {:__aliases__, [counter: 0, line: 0], [:Regex]},
     opts: p1, re_pattern: p2, source: p3]
  end

  def clean_ast(l1) when is_list(l1) do
    Enum.map(l1, &clean_ast/1)
  end

  def clean_ast({a1, line1, [{a2, line2, [{a3, line3, nil}]}, [do: l1]]}) do
    {a1, line1, [{a2, line2, [{a3, line3, nil}]},
     [do: Enum.map(l1, &clean_ast/1)]]}
  end

  def clean_ast({a1, [line: ln1], [:when, [line: ln2], l1]}) when is_list(l1) do
    {a1, [line: ln1], [:when, [line: ln2], Enum.map(l1, &clean_ast/1)]}
  end

  def clean_ast({a1, [line: ln1], l1}) when is_list(l1) do
    {a1, [line: ln1], Enum.map(l1, &clean_ast/1)}
  end

  def clean_ast(ast) do
    ast
  end

  def find_diff([h1|t1] = l1, [h2|t2] = l2) when is_list(l1) and is_list(l2) do
    unless l1 == l2 do
      IO.inspect("match1")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(h1, h2)
      find_diff(t1, t2)
    end
  end

  def find_diff({:do, {:__block__, _g1, l1}}, {:do, {:__block__, _g2, l2}}) do
    unless l1 == l2 do
      IO.inspect("match2")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff([do: {:__block__, _g1, l1}], [do: {:__block__, _g2, l2}]) do
    unless l1 == l2 do
      IO.inspect("match2")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff({:do, p1}, {:do, p2}) do
    unless p1 == p2 do
      IO.inspect("match3")
      IO.inspect(p1)
      IO.inspect(p2)
    end
  end

  def find_diff([do: p1], [do: p2]) do
    unless p1 == p2 do
      IO.inspect("match3")
      IO.inspect(p1)
      IO.inspect(p2)
    end
  end

  def find_diff({:defmodule, line, [_, l1]}, {:defmodule, line, [_, l2]}) do
    unless l1 == l2 do
      IO.inspect("match4")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(l1, l2)
    end
  end

  def find_diff({a, line, [h1|t1] = l1}, {a, line, [h2|t2] = l2})
                when is_list(l1) and is_list(l2) do
    unless l1 == l2 do
      IO.inspect("match5")
      IO.inspect(l1)
      IO.inspect(l2)
      find_diff(h1, h2)
      find_diff(t1, t2)
    end
  end

  def find_diff([], []) do
  end

  def find_diff(i1, i2) do
    IO.inspect("nothing")
    IO.inspect(i1)
    IO.inspect(i2)
  end

  @builddir '_build/test/lib/beam_to_ex_ast/ebin/'

  test "function" do
    fun_beam = {:function, 2, :hello, 0,
      [{:clause, 2, [], [],
        [{:call, 3, {:remote, 3, {:atom, 0, IO}, {:atom, 3, :puts}},
          [{:bin, 0,[
            {:bin_element,
             0,
             {:string, 0, 'Hello world'},
             :default,
             :default}
          ]}]
        }]
      }]
    }
    fun_ast = {:def, [line: 2], [
      {:hello, [line: 2], []},
      [do: {{:.,
             [line: 3],
             [{:__aliases__, [counter: 0, line: 3], [:IO]}, :puts]},
            [line: 3], ["Hello world"]
      }]
    ]}
    res1 = BeamToExAst.do_convert(fun_beam, {"", []})
    assert List.first(elem(res1, 1)) == fun_ast
  end

  test "module" do
    file = "lib/test_files/function.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunction.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "module function body" do
    file = "lib/test_files/function_body.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionBody.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "module functions" do
    file = "lib/test_files/functions.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctions.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "int" do
    file = "lib/test_files/function_int.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionInt.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "float" do
    file = "lib/test_files/function_float.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionFloat.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "atom" do
    file = "lib/test_files/function_atom.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionAtom.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  @tag :wip
  test "lists" do
    file = "lib/test_files/function_lists.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionLists.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    IO.inspect(mod_beam)
    IO.inspect(mod_ast)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "tuple" do
    file = "lib/test_files/function_tuple.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionTuple.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "map" do
    file = "lib/test_files/function_map.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionMap.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "math" do
    file = "lib/test_files/function_math.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionMath.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "bool compare" do
    file = "lib/test_files/function_bool_compare.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionBoolCompare.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "case" do
    file = "lib/test_files/function_case.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionCase.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
    # mod_ast2 = BeamToExAst.convert(mod_beam)
    # unless mod_ast2 == mod_ast do
    #   find_diff(mod_ast2, mod_ast)
    # end
  end

  test "pipe" do
    file = "lib/test_files/function_pipe.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionPipe.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == clean_ast(mod_ast)
  end

  test "binary" do
    file = "lib/test_files/function_binary.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionBinary.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  @tag :wip
  test "record" do
    file = "lib/test_files/function_record.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionRecord.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    # IO.inspect(mod_beam)
    # IO.inspect(mod_ast)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  @tag :wip
  test "dogfood" do
    file = "lib/beam_to_ex_ast.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.BeamToExAst.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    # IO.inspect(mod_beam)
    # IO.inspect(clean_ast(mod_ast))
    assert BeamToExAst.convert(mod_beam) == clean_ast(mod_ast)
    # mod_ast2 = BeamToExAst.convert(mod_beam)
    # unless mod_ast2 == clean_ast(mod_ast) do
    #   find_diff(mod_ast2, clean_ast(mod_ast))
    # end
  end
end
