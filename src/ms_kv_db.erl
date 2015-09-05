-module(ms_kv_db).
-include("ms_kv.hrl").

-export([
    close/1,
    delete/2,
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
            lager:warning("kv_db delete error: ~p~n", [Reason]),
            ok
    end.

-spec delete(binary(), eleveldb:db_ref()) -> ok.

delete(Key, DbRef) ->
    case eleveldb:delete(DbRef, Key, []) of
        ok ->
            ok;
        {error, Reason} ->
            lager:warning("kv_db delete error: ~p~n", [Reason]),
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
            lager:warning("kv_db get error: ~p~n", [Reason]),
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

-spec put(binary(), binary(), eleveldb:db_ref()) -> ok.

put(Key, Value, DbRef) ->
    case eleveldb:put(DbRef, Key, Value, [{sync, false}]) of
        ok ->
            ok;
        {error, Reason} ->
            lager:warning("kv_db put error: ~p~n", [Reason]),
            ok
    end.

-spec ref() -> eleveldb:db_ref().

ref() ->
    ms_base_global:lookup(?GLOBAL_NAME).

-spec size(eleveldb:db_ref()) -> pos_integer().

size(DbRef) ->
    {ok, Bytes} = eleveldb:status(DbRef, <<"leveldb.total-bytes">>),
    binary_to_integer(Bytes).
