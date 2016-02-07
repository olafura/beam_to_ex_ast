defmodule BeamToExAstTest do
  use ExUnit.Case
  doctest BeamToExAst

  test "test function" do
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

  test "test module" do
    file = "lib/test_files/function.ex"
    file_content = File.read!(file)
    beam_file = '_build/test/lib/beam_to_ex_ast/ebin/Elixir.TestFunction.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
        :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    #IO.inspect mod_beam
    #IO.inspect mod_ast
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end

  test "test module function body" do
    file = "lib/test_files/function_body.ex"
    file_content = File.read!(file)
    beam_file = '_build/test/lib/beam_to_ex_ast/ebin/Elixir.TestFunctionBody.beam'
    {:ok,{_,[{:abstract_code,{_,mod_beam}}]}} =
        :beam_lib.chunks(beam_file, [:abstract_code])
    {:ok, mod_ast} = Code.string_to_quoted(file_content)
    #IO.inspect mod_beam
    #IO.inspect mod_ast
    assert BeamToExAst.convert(mod_beam) == mod_ast
  end
end
