defmodule TestFunctionBinary do
  def hello() do
    <<"H", rest::binary>> = "Hello world"
    IO.puts("H" <> rest)
  end
end
