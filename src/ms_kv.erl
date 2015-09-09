-module(ms_kv).
-include("ms_kv.hrl").

-compile({no_auto_import, [put/2]}).

-export([
    get/1,
    put/2
]).

-define(SAMPLE_RATE, 1).

%% public
-spec get(binary()) -> {ok, binary()} | not_found.

get(Key) ->
    ms_base_metric:increment(<<"ms_kv.get.call">>, 1, ?SAMPLE_RATE),
    case ms_base:apply_hash(?APP, Key, ms_kv_cache, get, [Key]) of
        {ok, Value} ->
            ms_base_metric:increment(<<"ms_kv.get.cache">>, 1, ?SAMPLE_RATE),
            {ok, Value};
        _ ->
            case ms_kv_db:get(Key) of
                not_found ->
                    ms_base_metric:increment(<<"ms_kv.get.not_found">>, 1,
                        ?SAMPLE_RATE),
                    read_repair(Key);
                {ok, Value} ->
                    ms_base_metric:increment(<<"ms_kv.get.db">>, 1,
                        ?SAMPLE_RATE),
                    ms_base:apply_hash(?APP, Key, ms_kv_cache, put,
                        [Key, Value]),
                    {ok, Value}
            end
    end.

-spec put(binary(), binary()) -> [ok].

put(Key, Value) ->
    ms_base:apply_all(?APP, ms_kv_db, put, [Key, Value]).

%% private
pick_value([]) ->
    not_found;
pick_value([not_found | T]) ->
    pick_value(T);
pick_value([Value | _T]) ->
    Value.

read_repair(Key) ->
    Values = ms_base:apply_all_not_local(?APP, ms_kv_db, get, [Key]),
    case pick_value(Values) of
        not_found ->
            not_found;
        Value ->
            put(Key, Value),
            Value
    end.
