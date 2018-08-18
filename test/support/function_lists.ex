defmodule TestFunctionLists do
  def hello() do
    for <<c <- " hello world ">>, do: <<c>>

    for <<c <- " hello world ">> do
      IO.inspect("prufa")
      <<c>>
    end

    for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>
    # This is kind of complex since it gets mangled in the compile process
    # for <<c <- " hello world ">>, c != ?\s, into: "hi, ", do: <<c>>
    IO.inspect('Hello world')
    IO.inspect([1, 2, 3])
  end
end
