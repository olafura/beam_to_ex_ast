defmodule TestFunctionAtom do
  def hello() do
    IO.puts(true)
    IO.puts(:atom)
    IO.puts(Atom.to_string(:atom))
  end
end
