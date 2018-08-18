defmodule TestFunctionPipe do
  def hello() do
    "Hello world"
    |> IO.puts()
  end
end
