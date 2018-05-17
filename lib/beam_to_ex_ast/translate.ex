import ProtocolEx

defprotocolEx BeamToExAst.Translate do
  def to_elixir(ast, _opts) do
    # s1 = :forms.from_abstract(ast)
    # |> List.to_string()
    s1 = inspect(ast)

    {:=, [], [{:_untranslated, [], nil}, s1]}
  end
end
