

# Module ms_kv_db #
* [Function Index](#index)
* [Function Details](#functions)

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#close-1">close/1</a></td><td></td></tr><tr><td valign="top"><a href="#delete-2">delete/2</a></td><td></td></tr><tr><td valign="top"><a href="#get-2">get/2</a></td><td></td></tr><tr><td valign="top"><a href="#open-1">open/1</a></td><td></td></tr><tr><td valign="top"><a href="#put-3">put/3</a></td><td></td></tr><tr><td valign="top"><a href="#ref-0">ref/0</a></td><td></td></tr><tr><td valign="top"><a href="#size-1">size/1</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="close-1"></a>

### close/1 ###

<pre><code>
close(DbRef::<a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>) -&gt; ok
</code></pre>
<br />

<a name="delete-2"></a>

### delete/2 ###

<pre><code>
delete(Key::binary(), DbRef::<a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>) -&gt; ok
</code></pre>
<br />

<a name="get-2"></a>

### get/2 ###

<pre><code>
get(Key::binary(), DbRef::<a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>) -&gt; {ok, term()} | not_found
</code></pre>
<br />

<a name="open-1"></a>

### open/1 ###

<pre><code>
open(Path::string()) -&gt; ok
</code></pre>
<br />

<a name="put-3"></a>

### put/3 ###

<pre><code>
put(Key::binary(), Value::binary(), DbRef::<a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>) -&gt; ok
</code></pre>
<br />

<a name="ref-0"></a>

### ref/0 ###

<pre><code>
ref() -&gt; <a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>
</code></pre>
<br />

<a name="size-1"></a>

### size/1 ###

<pre><code>
size(DbRef::<a href="eleveldb.md#type-db_ref">eleveldb:db_ref()</a>) -&gt; pos_integer()
</code></pre>
<br />

