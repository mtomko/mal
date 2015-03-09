open Core_kernel.Std

module Ast = struct       
  type t = [
    | `List of t list
    | `Nil
    | `Int of int
    | `Float of float
    | `Symbol of string
    | `String of string
    | `Bool of bool
  ]
end

let rec ast_to_string a =
  match a with
  | `List xs -> let subtrees = List.map ~f:ast_to_string xs in
                let subtree_strs = String.concat ~sep:" " subtrees in
                String.concat ["("; subtree_strs; ")"]
  | `Nil -> "nil"
  | `Int i -> Int.to_string i
  | `Float f -> Float.to_string f
  | `Symbol s -> s
  | `String s -> String.concat ["\""; s; "\""]
  | `Bool false -> "false"
  | `Bool true -> "true"

             
let print_ast a =
  print_endline (ast_to_string a)

                               
