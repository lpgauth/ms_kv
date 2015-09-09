

# Module ms_kv_db #
* [Function Index](#index)
* [Function Details](#functions)

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#close-0">close/0</a></td><td></td></tr><tr><td valign="top"><a href="#get-1">get/1</a></td><td></td></tr><tr><td valign="top"><a href="#open-1">open/1</a></td><td></td></tr><tr><td valign="top"><a href="#put-2">put/2</a></td><td></td></tr><tr><td valign="top"><a href="#ref-0">ref/0</a></td><td></td></tr><tr><td valign="top"><a href="#size-0">size/0</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="close-0"></a>

### close/0 ###

<pre><code>
close() -&gt; ok
</code></pre>
<br />

<a name="get-1"></a>

### get/1 ###

<pre><code>
get(Key::binary()) -&gt; {ok, term()} | not_found
</code></pre>
<br />

<a name="open-1"></a>

### open/1 ###

<pre><code>
open(Path::string()) -&gt; ok
</code></pre>
<br />

<a name="put-2"></a>

### put/2 ###

<pre><code>
put(Key::binary(), Value::binary()) -&gt; ok | {error, key_exists}
</code></pre>
<br />

<a name="ref-0"></a>

### ref/0 ###

<pre><code>
ref() -&gt; <a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>
</code></pre>
<br />

<a name="size-0"></a>

### size/0 ###

<pre><code>
size() -&gt; pos_integer()
</code></pre>
<br />

