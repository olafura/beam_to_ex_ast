import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.MapFieldExact, {:map_field_exact, _ln, _key, _val}, for: Translate do
  import BeamToExAst

  # This is a performace enhancing feature in the compiled code
  def to_elixir({:map_field_exact, _ln, _key, _val}) do
    nil
  end
end
