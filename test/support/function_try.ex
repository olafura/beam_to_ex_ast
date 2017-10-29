defmodule TestFunctionTry do
    def hello() do
      try do
        raise "oops"
      rescue
        e in RuntimeError -> e
      end
    end
end
