defmodule TestFunctionRecord do
  require Record
  Record.defrecord(:user, name: "Olaf", age: 36)

  @type user :: record(:user, name: String.t(), age: integer)

  def hello() do
    u1 = user()
    IO.puts("Hello " <> u1.name)
  end
end
