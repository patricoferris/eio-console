(lang dune 2.9)

(name ec)

(generate_opam_files true)

(source
 (github patricoferris/eio-console))

(license MIT)

(authors "Patrick Ferris")

(maintainers "patrick@sirref.org")

(package
 (name ec)
 (synopsis "Monitor live Eio programs")
 (description "Eio-console provides an executable that allows you to monitor OCaml programs using Eventring.")
 (depends
   eio_main
   websocket-eio
   (js_of_ocaml (>= 4.0.0))
   (domainslib :with-test)
   crunch
   brr
   brr-lwd
   ezjsonm))
