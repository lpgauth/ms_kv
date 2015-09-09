-module(ms_kv_db).
-include("ms_kv.hrl").

-compile({no_auto_import, [get/1]}).

-export([
    close/0,
    get/1,
    open/1,
    put/2,
    ref/0
]).

-define(GLOBAL_NAME, db_ref).

%% public
-spec close() -> ok.

close() ->
    hanoidb:close(ref()),
    ms_base_global:unregister(?GLOBAL_NAME).

-spec get(binary()) -> {ok, term()} | not_found.

get(Key) ->
    case hanoidb:lookup(ref(), Key) of
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
    {ok, DbRef} = hanoidb:open(Path),
    ms_base_global:register(db_ref, DbRef),
    ok.

-spec put(binary(), binary()) -> ok | {error, key_exists}.

put(Key, Value) ->
    case get(Key) of
        not_found ->
            case hanoidb:put(ref(), Key, Value) of
                ok ->
                    ok;
                {error, Reason} ->
                    lager:warning("ms_kv_db put error: ~p~n", [Reason]),
                    ok
            end;
        _Value ->
            {error, key_exists}
    end.

-spec ref() -> hanoidb:hanoidb().

ref() ->
    ms_base_global:lookup(?GLOBAL_NAME).
