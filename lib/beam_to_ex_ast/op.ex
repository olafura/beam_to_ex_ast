import ProtocolEx
alias BeamToExAst.Translate

defimplEx BeamToExAst.Op1, {:op, _ln, _op, _param}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:op, ln, op1, p1}, opts) do
    {clean_op(op1), [line: ln], [Translate.to_elixir(p1, opts)]}
  end
end
defimplEx BeamToExAst.Op2, {:op, _ln, _op, _param1, _param2}, for: Translate do
  import BeamToExAst
  alias BeamToExAst.Translate

  def to_elixir({:op, ln, op1, p1, p2}, opts) do
    {clean_op(op1), [line: ln],
     [insert_line_number(Translate.to_elixir(p1, opts), ln), Translate.to_elixir(p2, opts)]}
  end
end

