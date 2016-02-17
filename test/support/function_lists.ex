defmodule TestFunctionLists do
    def hello() do
        for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>
        for x <- 0..100, x*x > 3, do: x*2
        for n <- [1, 2, 3, 4], into: [], do: n * n
        for n <- [1, 2, 3, 4], do: n * n
        IO.inspect('Hello world')
        IO.inspect([1, 2, 3])
    end
end

