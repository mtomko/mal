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

(* Parse the value and print its output *)
let rec parse_and_print lexbuf =
  match parse_with_error lexbuf with
  | Some value ->
    Lisp.print_ast value;
    parse_and_print lexbuf
  | None -> ()

let loop filename () =
  let inx = In_channel.create filename in
  let lexbuf = Lexing.from_channel inx in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = filename };
  parse_and_print lexbuf;
  In_channel.close inx

(* repl support *)
let get_inchan = function
  | None | Some "-" ->
    ("stdin", In_channel.stdin)
  | Some filename ->
    (filename, In_channel.create filename)
                   
let read filename =
  let (chname, ch) = get_inchan filename in
  let lexbuf = Lexing.from_channel ch in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = chname };
  match parse_with_error lexbuf with
  | Some value -> value
  | None -> exit (-1)

let eval ast = ast

let print = Lisp.print_ast

let rep ch = ch |> read |> eval |> print
  
let rec repl () =
  Out_channel.output_string stdout "user> ";
  Out_channel.flush stdout;
  match In_channel.input_line stdin with
  | None -> ()
  | Some line ->
     Out_channel.output_lines stdout [(rep line)];
     Out_channel.flush stdout;
     repl ()
                   
(* The main routine *)
let () =
  Command.basic ~summary:"Parse and display JSON"
    Command.Spec.(empty +> anon ("filename" %: file))
    loop 
  |> Command.run
