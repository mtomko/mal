(** Create a lexbuf around stdin *)
val lexbuf_from_stdin : Lexing.lexbuf

(** Create a lexbuf around the provided file; return the lexbuf and in_channel *)                          
val lexbuf_from_file : string -> in_channel * Lexing.lexbuf 

(** Attempt to parse a Lisp AST from the lexbuf *)
val parse_with_error : Lexing.lexbuf -> Lisp.Ast.t option
