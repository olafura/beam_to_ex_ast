import ProtocolEx

defprotocolEx BeamToExAst.Translate do
  def to_elixir(ast, opts) do
    _opts = opts

    s1 =
      :forms.from_abstract(ast)
      |> List.to_string()

    {:=, [], [{:_untranslated, [], nil}, s1]}
  end
end
