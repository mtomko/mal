open Core_kernel.Std

let read x = x
let eval x = x
let print x = x
let rep x = x |> read |> eval |> print

let rec repl () =
  Out_channel.output_string stdout "user> ";
  Out_channel.flush stdout;
  match In_channel.input_line stdin with
  | None -> ()
  | Some line ->
     Out_channel.output_lines stdout [(rep line)];
     Out_channel.flush stdout;
     repl ()
       
let () = repl ()
