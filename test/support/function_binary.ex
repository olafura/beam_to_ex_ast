defmodule TestFunctionBinary do
    def hello() do
        <<"H", rest :: binary>> = "Hello world"
        IO.puts("H" <> rest)
        <<"H", rest2>> = "Hello world"
        IO.puts("H" <> rest2)
    end
end

