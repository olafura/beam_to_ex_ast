defmodule TestFunctionMap do
    def hello() do
        IO.inpect(%{a: 1, b: 2, c: 3})
        IO.inpect(%{"a" => 1, "b" => 2, "c"=> 3})
    end
end

