-define(APP, ms_kv).
-define(CHILD(Name), {Name, {Name, start_link, []}, permanent, 5000, worker, [Name]}).
-define(DEFAULT_CACHE_MAX_SIZE, 268435456). % 256 * 1024 * 1024
-define(DEFAULT_CACHE_TRIM_DELAY, 5000). % timer:seconds(5)
-define(DEFAULT_DB_PATH, "db").
-define(ETS_CACHE, ms_kv_cache).
-define(ETS_CACHE_LRU, ms_kv_cache_lru).
-define(ENV(Key, Default), application:get_env(?APP, Key, Default)).