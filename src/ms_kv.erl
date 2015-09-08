-module(ms_kv).
-include("ms_kv.hrl").

-compile({no_auto_import, [put/2]}).

-export([
    get/1,
    put/2
]).

%% public
-spec get(binary()) -> {ok, binary()} | not_found.

get(Key) ->
    case ms_kv_cache:get(Key) of
        {ok, Value} ->
            {ok, Value};
        not_found ->
            DbRef = ms_kv_db:ref(),
            case ms_kv_db:get(Key, DbRef) of
                not_found ->
                    read_repair(Key);
                {ok, Value} ->
                    ms_kv_cache:put(Key, Value),
                    {ok, Value}
            end
    end.

-spec put(binary(), binary()) -> [ok].

put(Key, Value) ->
    DbRef = ms_kv_db:ref(),
    ms_base:apply_all(?MODULE, ms_kv_db, put, [Key, Value, DbRef]).

%% private
read_repair(Key) ->
    case ms_base:apply_all_not_local(?MODULE, ms_kv, get, [Key]) of
        [] ->
            not_found;
        [Value | _] ->
            put(Key, Value),
            Value
    end.
