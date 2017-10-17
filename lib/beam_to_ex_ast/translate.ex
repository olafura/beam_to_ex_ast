import ProtocolEx

defprotocolEx BeamToExAst.Translate do
  def to_elixir(ast)
end
