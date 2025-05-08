defmodule BeamToExAst.Translate do
  def to_elixir({:atom, _ln, _a1} = ast, opts), do: BeamToExAst.Atom.to_elixir(ast, opts)
  def to_elixir({:bc, _ln, _param1, _param2} = ast, opts), do: BeamToExAst.Bc.to_elixir(ast, opts)

  def to_elixir({:b_generate, _ln, _param1, _param2} = ast, opts),
    do: BeamToExAst.BGenerate.to_elixir(ast, opts)

  def to_elixir({:bin_element, _ln, _block, _, _} = ast, opts),
    do: BeamToExAst.BinElement.to_elixir(ast, opts)

  def to_elixir({:bin, _ln, _params} = ast, opts), do: BeamToExAst.Bin.to_elixir(ast, opts)
  def to_elixir({:block, _ln, _param} = ast, opts), do: BeamToExAst.Block.to_elixir(ast, opts)

  def to_elixir({:call, _ln, _caller, _params} = ast, opts),
    do: BeamToExAst.Call.to_elixir(ast, opts)

  def to_elixir({:case, _ln, _param, _body} = ast, opts),
    do: BeamToExAst.Case.to_elixir(ast, opts)

  def to_elixir({:char, _ln, _c1} = ast, opts), do: BeamToExAst.Char.to_elixir(ast, opts)

  def to_elixir({:clause, _ln, _params, _guard, _body} = ast, opts),
    do: BeamToExAst.Clause.to_elixir(ast, opts)

  def to_elixir({:clauses, _params} = ast, opts), do: BeamToExAst.Clauses.to_elixir(ast, opts)

  def to_elixir({:cons, _ln, _param1, _param2} = ast, opts),
    do: BeamToExAst.Cons.to_elixir(ast, opts)

  def to_elixir({:float, _ln, _f1} = ast, opts), do: BeamToExAst.Float.to_elixir(ast, opts)
  def to_elixir({:fun, _ln, _params} = ast, opts), do: BeamToExAst.Fun.to_elixir(ast, opts)
  def to_elixir({:if, _ln, _params} = ast, opts), do: BeamToExAst.If.to_elixir(ast, opts)
  def to_elixir({:integer, _ln, _i1} = ast, opts), do: BeamToExAst.Integer.to_elixir(ast, opts)
  def to_elixir({:lc, _ln, _param1, _param2} = ast, opts), do: BeamToExAst.Lc.to_elixir(ast, opts)
  def to_elixir(ast, opts) when is_list(ast), do: BeamToExAst.List.to_elixir(ast, opts)
  def to_elixir({:map, _ln, _items} = ast, opts), do: BeamToExAst.Map.to_elixir(ast, opts)

  def to_elixir({:map_field_assoc, _ln, _key, _val} = ast, opts),
    do: BeamToExAst.MapFieldAssoc.to_elixir(ast, opts)

  def to_elixir({:map_field_exact, _ln, _key, _val} = ast, opts),
    do: BeamToExAst.MapFieldExact.to_elixir(ast, opts)

  def to_elixir({:match, _ln, _param1, _param2} = ast, opts),
    do: BeamToExAst.Match.to_elixir(ast, opts)

  def to_elixir({nil, _ln} = ast, opts), do: BeamToExAst.Nil.to_elixir(ast, opts)
  def to_elixir({:op, _ln, _op, _param} = ast, opts), do: BeamToExAst.Op1.to_elixir(ast, opts)

  def to_elixir({:op, _ln, _op, _param1, _param2} = ast, opts),
    do: BeamToExAst.Op2.to_elixir(ast, opts)

  def to_elixir({:receive, _ln, _params} = ast, opts),
    do: BeamToExAst.Receive1.to_elixir(ast, opts)

  def to_elixir({:receive, _ln, _params, _period, _after_body} = ast, opts),
    do: BeamToExAst.Receive2.to_elixir(ast, opts)

  def to_elixir({:record, _ln, _name, _params} = ast, opts),
    do: BeamToExAst.Record.to_elixir(ast, opts)

  def to_elixir({:record_field, _ln, _param1, _param2} = ast, opts),
    do: BeamToExAst.RecordField.to_elixir(ast, opts)

  def to_elixir({:remote, _ln, _param1, _param2} = ast, opts),
    do: BeamToExAst.Remote.to_elixir(ast, opts)

  def to_elixir({:string, _ln, _s1} = ast, opts), do: BeamToExAst.String.to_elixir(ast, opts)

  def to_elixir(
        {:try, _ln, _params, _else_params, _catch_rescue_params, _after_params} = ast,
        opts
      ),
      do: BeamToExAst.Try.to_elixir(ast, opts)

  def to_elixir({:tuple, _ln, _items} = ast, opts), do: BeamToExAst.Tuple.to_elixir(ast, opts)
  def to_elixir({:var, _ln, _var} = ast, opts), do: BeamToExAst.Var.to_elixir(ast, opts)
  # def to_elixir( = ast, opts), do: .to_elixir(ast, opts)

  def to_elixir(ast, opts) do
    _opts = opts

    s1 =
      :forms.from_abstract(ast)
      |> List.to_string()

    {:=, [], [{:_untranslated, [], nil}, s1]}
  end
end
