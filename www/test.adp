<master src="master">
<property name="context_bar"></property>
<property name="title">test</property>

<pre><%=[ns_quotehtml "{}{}{}<><><><foo>bar</bar>"]%></pre>

<pre><%=[ad_conn location] [ad_conn package_url] %></pre>
<pre><%= [bboard_message_url 8035 1592]%></pre>
<pre><%= [bboard_message_url -absolute 8035 1592]%></pre>
<pre><%= %></pre>
<pre><%= %></pre>
<pre><%= %></pre>


<% bboard_garbage_collect %>