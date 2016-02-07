defmodule TestFunctionBoolCompare do
    def hello() do
        IO.inspect(true === false)
        IO.inspect(true == false)
        IO.inspect(true !== false)
        IO.inspect(true != false)
        IO.inspect(1 <= 2)
        IO.inspect(1 < 2)
        IO.inspect(1 > 2)
        IO.inspect(1 =~ "1")
    end
end

