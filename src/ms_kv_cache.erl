-module(ms_kv_cache).
-include("ms_kv.hrl").

-export([
    get/1,
    put/2,
    size/0,
    start/0,
    stop/0
]).

%% public
-spec get(binary()) -> {ok, term()} | not_found.

get(Key) ->
    try ets:lookup_element(?ETS_CACHE, Key, 2) of
        Value ->
            {ok, Value}
    catch
        error:badarg ->
            not_found
    end.

-spec put(binary(), binary()) -> ok.

put(Key, Value) ->
    Key2 = {unix_time(), Key},
    ets:insert_new(?ETS_CACHE, {Key, Value, Key2}),
    ets:insert_new(?ETS_CACHE_LRU, {Key2, true}),
    ok.

-spec size() -> pos_integer().

size() ->
    WordSize = erlang:system_info(wordsize),
    Memory = ets:info(?ETS_CACHE, memory),
    WordSize * Memory.

-spec start() -> ok.

start() ->
    Opts = [
        named_table,
        public,
        {read_concurrency, true},
        {write_concurrency, true}
    ],

    try
        ets:new(?ETS_CACHE, [set] ++ Opts),
        ets:new(?ETS_CACHE_LRU, [ordered_set] ++ Opts),
        ok
    catch
        error:badarg ->
            ok
    end.

-spec stop() -> ok.

stop() ->
    try
        ets:delete(?ETS_CACHE),
        ets:delete(?ETS_CACHE_LRU),
        ok
    catch
        error:badarg ->
            ok
    end.

%% private
unix_time() ->
    {Mega, Sec, Micro} = os:timestamp(),
    (Mega * 1000000 * 1000000 + Sec * 1000000) + Micro.
