-module(ms_kv_test).
-include_lib("ms_kv/include/ms_kv.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(DB_PATH, "../.eunit/db").

-spec test() -> ok.

%% runners
-spec ms_kv_test_() -> ok.

ms_kv_test_() ->
    {setup,
        fun () -> setup([
            {cache_max_size, 10000},
            {cache_trim_delay, 1000}
        ]) end,
        fun (_) -> cleanup() end,
    [
        fun kv/0,
        fun kv_cache_lru_server/0
    ]}.

%% tests
kv() ->
    Key = random(),
    Value = random(),
    [ok] = ms_kv:put(Key, Value),
    [{error, key_exists}] = ms_kv:put(Key, Value),
    {ok, Value} = ms_kv:get(Key),
    {ok, Value} = ms_kv:get(Key),
    not_found = ms_kv:get(random()).

kv_cache_lru_server() ->
    [fun () ->
         Key = random(),
         Value = random(),
         ms_kv:put(Key, Value),
         ms_kv:get(Key)
     end () || _ <- lists:seq(1, 1000)],
    timer:sleep(2000),
    ?assert(ms_kv_cache:size() < 10000).

%% utils
cleanup() ->
    ms_kv_app:stop(),
    file:delete(?DB_PATH).

random() ->
    crypto:rand_bytes(24).

setup(KeyVals) ->
    error_logger:tty(false),
    application:load(?APP),
    set_env(KeyVals),
    application:load(lager),
    application:set_env(lager, error_logger_redirect, false),
    application:load(ms_base),
    application:set_env(ms_base, local_resource_types, [ms_kv]),
    application:set_env(ms_base, target_resource_types, [ms_kv]),
    ms_kv_app:start().

set_env([]) ->
    ok;
set_env([{K, V} | T]) ->
    application:set_env(?APP, K, V),
    set_env(T).
