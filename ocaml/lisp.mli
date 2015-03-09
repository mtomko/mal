open Lexing

(** Lisp abstract syntax tree definition *)
module Ast : sig
  type t =
    [ `Bool of bool
    | `Int of int
    | `List of t list
    | `Nil
    | `String of string
    | `Symbol of string ]
end

(** Converts an AST to a string *)      
val ast_to_string : Ast.t -> string

(** Prints an AST *)                             
val print_ast : Ast.t -> unit

