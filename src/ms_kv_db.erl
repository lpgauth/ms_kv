-module(ms_kv_db).
-include("ms_kv.hrl").

-compile({no_auto_import, [get/1]}).

-export([
    close/0,
    get/1,
    open/1,
    put/2,
    ref/0,
    size/0
]).

-define(GLOBAL_NAME, db_ref).

%% public
-spec close() -> ok.

close() ->
    case eleveldb:close(ref()) of
        ok ->
            ms_base_global:unregister(?GLOBAL_NAME),
            ok;
        {error, Reason} ->
            lager:warning("ms_kv_db close error: ~p~n", [Reason]),
            ok
    end.

-spec get(binary()) -> {ok, term()} | not_found.

get(Key) ->
    case eleveldb:get(ref(), Key, [{fill_cache, false}]) of
        {ok, Value} ->
            {ok, Value};
        not_found ->
            not_found;
        {error, Reason} ->
            lager:warning("ms_kv_db get error: ~p~n", [Reason]),
            not_found
    end.

-spec open(string()) -> ok.

open(Path) ->
    {ok, DbRef} = eleveldb:open(Path, [
        {compression, true},
        {create_if_missing, true},
        {use_bloomfilter, true}
    ]),
    ms_base_global:register(db_ref, DbRef),
    ok.

-spec put(binary(), binary()) -> ok | {error, key_exists}.

put(Key, Value) ->
    case get(Key) of
        not_found ->
            case eleveldb:put(ref(), Key, Value, [{sync, false}]) of
                ok ->
                    ok;
                {error, Reason} ->
                    lager:warning("ms_kv_db put error: ~p~n", [Reason]),
                    ok
            end;
        _Value ->
            {error, key_exists}
    end.

-spec ref() -> eleveldb:db_ref().

ref() ->
    ms_base_global:lookup(?GLOBAL_NAME).

-spec size() -> pos_integer().

size() ->
    {ok, Bytes} = eleveldb:status(ref(), <<"leveldb.total-bytes">>),
    binary_to_integer(Bytes).
