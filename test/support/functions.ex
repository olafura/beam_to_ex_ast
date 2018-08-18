defmodule TestFunctions do
  def hello() do
    test_log("Hello world")
  end

  def test_log(msg) do
    IO.puts(msg)
  end
end
