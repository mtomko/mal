open Core.Std
open Lexer
open Lexing

(* Print a location in the parse tree *)       
let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

(* Parse the buffer and handle syntax errors *)
let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

let eval ast = ast

let print = Lisp.print_ast
         
let lexbuf_from_stdin =
  let lexbuf = Lexing.from_channel stdin in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = "stdin" };
  lexbuf
                   
let lexbuf_from_file filename =
  let inx = In_channel.create filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  (inx, lexbuf)
                    
(* Parse the value and print its output *)
let rec interpret ?prompt lexbuf =
  (match prompt with
   | Some p -> Out_channel.output_string stdout p;
               Out_channel.flush stdout;
   | None -> ());
  match parse_with_error lexbuf with
  | None -> ()
  | Some value ->
    value |> eval |> print;
    interpret lexbuf ?prompt
                   
let main filename () =
  match filename with
  | Some filename ->
     let (inc, lexbuf) = lexbuf_from_file filename in
     interpret lexbuf;
     In_channel.close inc
  | None ->
     let lexbuf = lexbuf_from_stdin in
     interpret lexbuf ~prompt:"user> "

(* The main routine *)
let () =
  Command.basic ~summary:"Parse and display Lisp"
    Command.Spec.(empty +> anon (maybe ("filename" %: file)))
    main 
  |> Command.run
