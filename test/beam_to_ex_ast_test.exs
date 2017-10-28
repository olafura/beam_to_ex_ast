defmodule BeamToExAstTest do
  use ExUnit.Case
  doctest BeamToExAst
  ExUnit.configure(exclude: [wip: true, dogfood: true])
  import BeamToExAstTestUtils

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
    file = "test/support/function.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunction.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "module function body" do
    file = "test/support/function_body.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionBody.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert clean_ast(BeamToExAst.convert(mod_beam)) == clean_ast(mod_ast)
  end

  test "module functions" do
    file = "test/support/functions.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctions.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "int" do
    file = "test/support/function_int.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionInt.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "float" do
    file = "test/support/function_float.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionFloat.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "atom" do
    file = "test/support/function_atom.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionAtom.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "lists" do
    file = "test/support/function_lists.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionLists.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    # IO.inspect(mod_beam)
    # IO.inspect(mod_ast)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "tuple" do
    file = "test/support/function_tuple.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionTuple.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "map" do
    file = "test/support/function_map.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionMap.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "math" do
    file = "test/support/function_math.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionMath.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "bool compare" do
    file = "test/support/function_bool_compare.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionBoolCompare.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "case" do
    file = "test/support/function_case.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionCase.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    # IO.inspect(mod_beam)
    assert BeamToExAst.convert(mod_beam) == mod_ast
    # mod_ast2 = BeamToExAst.convert(mod_beam)
    # unless mod_ast2 == mod_ast do
    #   find_diff(mod_ast2, mod_ast)
    # end
  end

  test "pipe" do
    file = "test/support/function_pipe.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionPipe.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert clean_ast(BeamToExAst.convert(mod_beam)) == clean_ast(mod_ast)
  end

  test "binary" do
    file = "test/support/function_binary.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionBinary.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  @tag :wip
  test "record" do
    file = "test/support/function_record.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.TestFunctionRecord.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    # IO.inspect(mod_beam)
    # IO.inspect(mod_ast)
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  @tag :dogfood
  test "dogfood" do
    file = "lib/beam_to_ex_ast.ex"
    file_content = File.read!(file)
    beam_file = @builddir ++ 'Elixir.BeamToExAst.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
      :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    # IO.inspect(mod_beam)
    # IO.inspect(clean_ast(mod_ast))
    assert clean_ast(BeamToExAst.convert(mod_beam)) == clean_ast(mod_ast)
    # mod_ast2 = BeamToExAst.convert(mod_beam)
    # unless mod_ast2 == clean_ast(mod_ast) do
    #   find_diff(mod_ast2, clean_ast(mod_ast))
    # end
  end
end
