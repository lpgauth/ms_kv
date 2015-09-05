-module(ms_kv_cache_lru_server).
-include("ms_kv.hrl").

-export([
    start_link/0
]).

-behaviour(gen_server).
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    max_size   :: pos_integer(),
    timer_ref  :: reference() | undefined,
    trim_delay :: pos_integer()
}).

-type state() :: #state {}.

%% public
-spec start_link() -> {ok, pid()}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% gen_server callbacks
-spec init([]) -> {ok, state()}.

init([]) ->
    MaxSize = ?ENV(cache_max_size, ?DEFAULT_CACHE_MAX_SIZE),
    TrimDelay = ?ENV(cache_trim_delay, ?DEFAULT_CACHE_TRIM_DELAY),

    {ok, #state {
        max_size = MaxSize,
        timer_ref = trim_after(TrimDelay),
        trim_delay = TrimDelay
    }}.

-spec handle_call(term(), term(), state()) -> {reply, ignored, state()}.

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

-spec handle_cast(term(), state()) -> {noreply, state()}.

handle_cast(_Msg, State) ->
    {noreply, State}.

-spec handle_info(trim, state()) -> {noreply, state()}.

handle_info(trim, #state {
        max_size = MaxSize,
        trim_delay = TrimDelay
    } = State) ->

    ok = trim(MaxSize),

    {noreply, State#state {
        timer_ref = trim_after(TrimDelay)
    }}.

-spec terminate(term(), state()) -> ok.

terminate(_Reason, _State) ->
    ok.

-spec code_change(term(), state(), term()) -> {ok, state()}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% private
trim(MaxSize) ->
    case ms_kv_cache:size() > MaxSize of
        true ->
            case ets:first(?ETS_CACHE_LRU) of
                '$end_of_table' ->
                    ok;
                {_, Key} = LruKey ->
                    ets:delete(?ETS_CACHE, Key),
                    ets:delete(?ETS_CACHE_LRU, LruKey),
                    trim(MaxSize)
            end;
        false ->
            ok
    end.

trim_after(TrimDelay) ->
    erlang:send_after(TrimDelay, self(), trim).
