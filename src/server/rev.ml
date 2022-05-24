open Runtime_events

let tracing = Atomic.make true

let runtime_counter_name counter =
  match counter with
  | EV_C_ALLOC_JUMP -> "C_ALLOC_JUMP"
  | EV_C_FORCE_MINOR_ALLOC_SMALL -> "C_FORCE_MINOR_ALLOC_SMALL"
  | EV_C_FORCE_MINOR_MAKE_VECT -> "C_FORCE_MINOR_MAKE_VECT"
  | EV_C_FORCE_MINOR_SET_MINOR_HEAP_SIZE -> "C_FORCE_MINOR_SET_MINOR_HEAP_SIZE"
  | EV_C_FORCE_MINOR_WEAK -> "C_FORCE_MINOR_WEAK"
  | EV_C_FORCE_MINOR_MEMPROF -> "C_FORCE_MINOR_MEMPROF"
  | EV_C_MAJOR_MARK_SLICE_REMAIN -> "C_MAJOR_MARK_SLICE_REMAIN"
  | EV_C_MAJOR_MARK_SLICE_FIELDS -> "C_MAJOR_MARK_SLICE_FIELDS"
  | EV_C_MAJOR_MARK_SLICE_POINTERS -> "C_MAJOR_MARK_SLICE_POINTERS"
  | EV_C_MAJOR_WORK_EXTRA -> "C_MAJOR_WORK_EXTRA"
  | EV_C_MAJOR_WORK_MARK -> "C_MAJOR_WORK_MARK"
  | EV_C_MAJOR_WORK_SWEEP -> "C_MAJOR_WORK_SWEEP"
  | EV_C_MINOR_PROMOTED -> "C_MINOR_PROMOTED"
  | EV_C_REQUEST_MAJOR_ALLOC_SHR -> "C_REQUEST_MAJOR_ALLOC_SHR"
  | EV_C_REQUEST_MAJOR_ADJUST_GC_SPEED -> "C_REQUEST_MAJOR_ADJUST_GC_SPEED"
  | EV_C_REQUEST_MINOR_REALLOC_REF_TABLE -> "C_REQUEST_MINOR_REALLOC_REF_TABLE"
  | EV_C_REQUEST_MINOR_REALLOC_EPHE_REF_TABLE ->
      "C_REQUEST_MINOR_REALLOC_EPHE_REF_TABLE"
  | EV_C_REQUEST_MINOR_REALLOC_CUSTOM_TABLE ->
      "C_REQUEST_MINOR_REALLOC_CUSTOM_TABLE"

let runtime_phase_name phase =
  match phase with
  | EV_COMPACT_MAIN -> "COMPACT_MAIN"
  | EV_COMPACT_RECOMPACT -> "COMPACT_RECOMPACT"
  | EV_EXPLICIT_GC_SET -> "EXPLICIT_GC_SET"
  | EV_EXPLICIT_GC_STAT -> "EXPLICIT_GC_STAT"
  | EV_EXPLICIT_GC_MINOR -> "EXPLICIT_GC_MINOR"
  | EV_EXPLICIT_GC_MAJOR -> "EXPLICIT_GC_MAJOR"
  | EV_EXPLICIT_GC_FULL_MAJOR -> "EXPLICIT_GC_FULL_MAJOR"
  | EV_EXPLICIT_GC_COMPACT -> "EXPLICIT_GC_COMPACT"
  | EV_MAJOR -> "MAJOR"
  | EV_MAJOR_ROOTS -> "MAJOR_ROOTS"
  | EV_MAJOR_SWEEP -> "MAJOR_SWEEP"
  | EV_MAJOR_MARK_ROOTS -> "MAJOR_MARK_ROOTS"
  | EV_MAJOR_MARK_MAIN -> "MAJOR_MARK_MAIN"
  | EV_MAJOR_MARK_FINAL -> "MAJOR_MARK_FINAL"
  | EV_MAJOR_MARK -> "MAJOR_MARK"
  | EV_MAJOR_MARK_GLOBAL_ROOTS_SLICE -> "MAJOR_MARK_GLOBAL_ROOTS_SLICE"
  | EV_MAJOR_ROOTS_GLOBAL -> "MAJOR_ROOTS_GLOBAL"
  | EV_MAJOR_ROOTS_DYNAMIC_GLOBAL -> "MAJOR_ROOTS_DYNAMIC_GLOBAL"
  | EV_MAJOR_ROOTS_LOCAL -> "MAJOR_ROOTS_LOCAL"
  | EV_MAJOR_ROOTS_C -> "MAJOR_ROOTS_C"
  | EV_MAJOR_ROOTS_FINALISED -> "MAJOR_ROOTS_FINALISED"
  | EV_MAJOR_ROOTS_MEMPROF -> "MAJOR_ROOTS_MEMPROF"
  | EV_MAJOR_ROOTS_HOOK -> "MAJOR_ROOTS_HOOK"
  | EV_MAJOR_CHECK_AND_COMPACT -> "MAJOR_CHECK_AND_COMPACT"
  | EV_MINOR -> "MINOR"
  | EV_MINOR_LOCAL_ROOTS -> "MINOR_LOCAL_ROOTS"
  | EV_MINOR_REF_TABLES -> "MINOR_REF_TABLES"
  | EV_MINOR_COPY -> "MINOR_COPY"
  | EV_MINOR_UPDATE_WEAK -> "MINOR_UPDATE_WEAK"
  | EV_MINOR_FINALIZED -> "MINOR_FINALIZED"
  | EV_EXPLICIT_GC_MAJOR_SLICE -> "EXPLICIT_GC_MAJOR_SLICE"
  | EV_DOMAIN_SEND_INTERRUPT -> "DOMAIN_SEND_INTERRUPT"
  | EV_DOMAIN_IDLE_WAIT -> "DOMAIN_IDLE_WAIT"
  | EV_FINALISE_UPDATE_FIRST -> "FINALISE_UPDATE_FIRST"
  | EV_FINALISE_UPDATE_LAST -> "FINALISE_UPDATE_LAST"
  | EV_INTERRUPT_REMOTE -> "INTERRUPT_REMOTE"
  | EV_MAJOR_EPHE_MARK -> "MAJOR_EPHE_MARK"
  | EV_MAJOR_EPHE_SWEEP -> "MAJOR_EPHE_SWEEP"
  | EV_MAJOR_FINISH_MARKING -> "MAJOR_FINISH_MARKING"
  | EV_MAJOR_GC_CYCLE_DOMAINS -> "MAJOR_GC_CYCLE_DOMAINS"
  | EV_MAJOR_GC_PHASE_CHANGE -> "MAJOR_GC_PHASE_CHANGE"
  | EV_MAJOR_GC_STW -> "MAJOR_GC_STW"
  | EV_MAJOR_MARK_OPPORTUNISTIC -> "MAJOR_MARK_OPPORTUNISTIC"
  | EV_MAJOR_SLICE -> "MAJOR_SLICE"
  | EV_MINOR_CLEAR -> "MINOR_CLEAR"
  | EV_MINOR_FINALIZERS_OLDIFY -> "MINOR_FINALIZERS_OLDIFY"
  | EV_MINOR_GLOBAL_ROOTS -> "MINOR_GLOBAL_ROOTS"
  | EV_MINOR_LEAVE_BARRIER -> "MINOR_LEAVE_BARRIER"
  | EV_STW_API_BARRIER -> "STW_API_BARRIER"
  | EV_STW_HANDLER -> "STW_HANDLER"
  | EV_STW_LEADER -> "STW_LEADER"
  | EV_MAJOR_FINISH_SWEEPING -> "MAJOR_FINISH_SWEEPING"
  | EV_MINOR_FINALIZERS_ADMIN -> "MINOR_FINALIZERS_ADMIN"
  | EV_MINOR_REMEMBERED_SET -> "MINOR_REMEMBERED_SET"
  | EV_MINOR_REMEMBERED_SET_PROMOTE -> "MINOR_REMEMBERED_SET_PROMOTE"
  | EV_MINOR_LOCAL_ROOTS_PROMOTE -> "MINOR_LOCAL_ROOTS_PROMOTE"
  | EV_DOMAIN_CONDITION_WAIT -> "DOMAIN_CONDITION_WAIT"
  | EV_MAJOR_FINISH_CYCLE -> "MAJOR_FINISH_CYCLE"
  | EV_DOMAIN_RESIZE_HEAP_RESERVATION -> "DOMAIN_RESIZE_HEAP_RESERVATION"

let lifecycle_name lifecycle =
  match lifecycle with
  | EV_RING_START -> "RING_START"
  | EV_RING_STOP -> "RING_STOP"
  | EV_RING_PAUSE -> "RING_PAUSE"
  | EV_RING_RESUME -> "RING_RESUME"
  | EV_FORK_PARENT -> "FORK_PARENT"
  | EV_FORK_CHILD -> "FORK_CHILD"
  | EV_DOMAIN_SPAWN -> "DOMAIN_SPAWN"
  | EV_DOMAIN_TERMINATE -> "DOMAIN_TERMINATE"

module Ezjsonm_parser = struct
  type t = Ezjsonm.value

  let catch_err f v =
    try Ok (f v) with Ezjsonm.Parse_error (_, s) -> Error (`Msg s)

  let find = Ezjsonm.find_opt
  let to_string t = catch_err Ezjsonm.get_string t
  let string = Ezjsonm.string
  let to_float t = catch_err Ezjsonm.get_float t
  let float = Ezjsonm.float
  let to_int t = catch_err Ezjsonm.get_int t
  let int = Ezjsonm.int
  let to_list f t = catch_err (Ezjsonm.get_list f) t
  let list f t = Ezjsonm.list f t
  let to_array f t = Result.map Array.of_list @@ to_list f t
  let array f t = list f (Array.to_list t)
  let obj = Ezjsonm.dict
  let null = `Null
  let is_null = function `Null -> true | _ -> false
end

module Events = struct
  include Ec_ev.Ev.Make (Ezjsonm_parser)
end

let send_data send data =
  let data = data |> Events.to_json |> Ezjsonm.value_to_string in
  send data

let tracing_func ws path_pid () =
  let cursor = create_cursor path_pid in
  let ts_to_ms ts =
    Int64.(to_float @@ div (Timestamp.to_int64 ts) (of_int 1000))
  in
  let runtime_begin (domain_id : Domain.id) ts phase =
    send_data ws
      (Events.System
         (`Phase
           {
             name = runtime_phase_name phase;
             ts = ts_to_ms ts;
             domain_id = (domain_id :> int);
           }))
  in
  let runtime_end (domain_id : Domain.id) ts phase =
    send_data ws
      (Events.System
         (`Phase
           {
             name = runtime_phase_name phase;
             ts = ts_to_ms ts;
             domain_id = (domain_id :> int);
           }))
  in
  let runtime_counter (domain_id : Domain.id) ts counter value =
    send_data ws
      (Events.System
         (`Counter
           ( {
               name = runtime_counter_name counter;
               ts = ts_to_ms ts;
               domain_id = (domain_id :> int);
             },
             value )))
  in
  let lifecycle (domain_id : Domain.id) ts l _ =
    send_data ws
      (Events.System
         (`Lifecycle
           {
             name = lifecycle_name l;
             ts = ts_to_ms ts;
             domain_id = (domain_id :> int);
           }))
  in
  let callbacks =
    Callbacks.create ~runtime_begin ~runtime_end ~runtime_counter ~lifecycle ()
  in
  let rec aux () =
    if Atomic.get tracing then (
      ignore (read_poll cursor callbacks None);
      Eio_unix.sleep 0.3;
      aux ())
    else ()
  in
  aux ()

let stop_trace_record () = Atomic.set tracing false
let start_trace_record ws path_pid = tracing_func ws path_pid ()
(* ignore (Domain.spawn (tracing_func ws path_pid)) *)
