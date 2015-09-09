

# Module ms_kv_cache #
* [Function Index](#index)
* [Function Details](#functions)

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#get-1">get/1</a></td><td></td></tr><tr><td valign="top"><a href="#put-2">put/2</a></td><td></td></tr><tr><td valign="top"><a href="#size-0">size/0</a></td><td></td></tr><tr><td valign="top"><a href="#start-0">start/0</a></td><td></td></tr><tr><td valign="top"><a href="#stop-0">stop/0</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="get-1"></a>

### get/1 ###

<pre><code>
get(Key::binary()) -&gt; {ok, term()} | not_found
</code></pre>
<br />

<a name="put-2"></a>

### put/2 ###

<pre><code>
put(Key::binary(), Value::binary()) -&gt; ok
</code></pre>
<br />

<a name="size-0"></a>

### size/0 ###

<pre><code>
size() -&gt; pos_integer()
</code></pre>
<br />

<a name="start-0"></a>

### start/0 ###

<pre><code>
start() -&gt; ok
</code></pre>
<br />

<a name="stop-0"></a>

### stop/0 ###

<pre><code>
stop() -&gt; ok
</code></pre>
<br />

