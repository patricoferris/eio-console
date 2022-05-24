# Tests for Eventring
---------------------

This directory contains example programs you can run to test the console. First build the examples with `dune build`. Then run the example enabling the eventring.

```sh
dune build
OCAML_EVENTRING_START=1 _build/default/test/<name>.exe <args>
```

This will start running the programs which tend to be long-running in nature and a new `<pid>.eventring` file should appear in the directory you ran the command from. This can be passed to the console in order to anaylse the information.

Some programs were borrowed from the excellent [sandmark benchmarks](https://github.com/ocaml-bench/sandmark/) and the [Domainslib](https://github.com/ocaml-multicore/domainslib) examples.