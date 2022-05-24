let () =
  let iter = try int_of_string Sys.argv.(1) with _ -> 100 in
  for _ = 0 to iter do
    Gc.full_major ();
    Unix.sleepf 1.500
  done
