-module(ms_kv).
-include("ms_kv.hrl").

-export([
    delete/1,
    get/1,
    put/2
]).

%% public
-spec delete(binary()) -> ok.
delete(Key) ->
    ms_kv_cache:delete(Key),
    DbRef = ms_kv_db:ref(),
    ms_kv_db:delete(Key, DbRef).

-spec get(binary()) -> {ok, binary()} | not_found.

get(Key) ->
    case ms_kv_cache:get(Key) of
        {ok, Value} ->
            {ok, Value};
        not_found ->
            DbRef = ms_kv_db:ref(),
            case ms_kv_db:get(Key, DbRef) of
                not_found ->
                    not_found;
                {ok, Value} ->
                    ms_kv_cache:put(Key, Value),
                    {ok, Value}
            end
    end.

-spec put(binary(), binary()) -> ok.

put(Key, Value) ->
    DbRef = ms_kv_db:ref(),
    ms_kv_db:put(Key, Value, DbRef).
