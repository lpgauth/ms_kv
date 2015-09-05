-module(ms_kv_app).
-include("ms_kv.hrl").

%% public
-export([
    start/0,
    stop/0
]).

-behaviour(application).
-export([
    start/2,
    stop/1
]).

%% public
-spec start() -> {ok, [atom()]}.

start() ->
    application:ensure_all_started(?APP).

-spec stop() -> ok | {error, {not_started, ?APP}}.

stop() ->
    application:stop(?APP).

%% application callbacks
-spec start(application:start_type(), term()) -> {ok, pid()}.

start(_StartType, _StartArgs) ->
    DbPath = application:get_env(?APP, db_path, ?DEFAULT_DB_PATH),

    ok = ms_kv_cache:start(),
    ok = ms_kv_db:open(DbPath),

    ms_kv_sup:start_link().

-spec stop(term()) -> ok.

stop(_State) ->
    ms_kv_db:close(ms_kv_db:ref()),
    ms_kv_cache:stop(),
    ok.
