%token NIL
%token <int> INT
%token <string> SYMBOL
%token <string> STRING
%token TRUE
%token FALSE
%token LEFT_PAREN
%token RIGHT_PAREN
%token EOF

%start <Lisp.Ast.t option> prog
%%

prog:
  | EOF     { None }
  | a = ast { Some a }
  ;

ast:
  | LEFT_PAREN; vl = list_fields; RIGHT_PAREN 
    { `List vl }
  | i = INT
    { `Int i }
  | s = SYMBOL
    { `Symbol s }
  | s = STRING
    { `String s }
  | TRUE
    { `Bool true }
  | FALSE
    { `Bool false }
  | NIL
    { `Nil }
  ;

list_fields:
  vl = list(ast) { vl } ;
                
