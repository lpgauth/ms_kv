-module(ms_kv_db).
-include("ms_kv.hrl").

-export([
    close/1,
    get/2,
    open/1,
    put/3,
    ref/0,
    size/1
]).

-define(GLOBAL_NAME, db_ref).

%% public
-spec close(eleveldb:db_ref()) -> ok.

close(DbRef) ->
    case eleveldb:close(DbRef) of
        ok ->
            ms_base_global:unregister(?GLOBAL_NAME),
            ok;
        {error, Reason} ->
            lager:warning("ms_kv_db close error: ~p~n", [Reason]),
            ok
    end.

-spec get(binary(), eleveldb:db_ref()) -> {ok, term()} | not_found.

get(Key, DbRef) ->
    case eleveldb:get(DbRef, Key, [{fill_cache, false}]) of
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

-spec put(binary(), binary(), eleveldb:db_ref()) -> ok | {error, key_exists}.

put(Key, Value, DbRef) ->
    case get(Key, DbRef) of
        not_found ->
            case eleveldb:put(DbRef, Key, Value, [{sync, false}]) of
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

-spec size(eleveldb:db_ref()) -> pos_integer().

size(DbRef) ->
    {ok, Bytes} = eleveldb:status(DbRef, <<"leveldb.total-bytes">>),
    binary_to_integer(Bytes).
