defmodule TestFunction do
    def hello() do
        prufa = fn() -> IO.puts("Hello world") end
        prufa.()
    end
end

