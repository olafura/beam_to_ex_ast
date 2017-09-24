defmodule TestFunctionMap do
    def hello() do
        IO.inspect(%{a: 1, b: 2, c: 3})
        IO.inspect(%{"a" => 1, "b" => 2, "c"=> 3})
    end
end

