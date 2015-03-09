open Core.Std
open Lexer
open Lexing

let eval ast = ast

let print = Lisp.print_ast

(* Parse the value and print its output *)
let rec interpret ?prompt lexbuf =
  (match prompt with
   | Some p -> Out_channel.output_string stdout p;
               Out_channel.flush stdout;
   | None -> ());
  match Reader.parse_with_error lexbuf with
  | None -> ()
  | Some value ->
    value |> eval |> print;
    interpret lexbuf ?prompt

(* The main routine *)
let main filename () =
  match filename with
  | Some filename ->
     let (inc, lexbuf) = Reader.lexbuf_from_file filename in
     interpret lexbuf;
     In_channel.close inc
  | None ->
     let lexbuf = Reader.lexbuf_from_stdin in
     interpret lexbuf ~prompt:"user> "

let () =
  Command.basic ~summary:"Parse and display Lisp"
    Command.Spec.(empty +> anon (maybe ("filename" %: file)))
    main 
  |> Command.run
