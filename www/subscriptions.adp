<master src="master">
<property name="context_bar">Email Alerts</property>
<property name="title">Manage Email Alerts</property>

You have registered for the following email alerts. An email alert
will send you an email whenever an update happens in the given
context. For example, a bboard email alert will notify you by email
whenever a new posting occurs in the specific bboard. A thread email
alert, on the other hand, will only alert you if a posting has been
made within that given thread.
<p>

<h4>Bboards</h4>

<ul>

<if @forum_subs:rowcount@ gt 0>
<multiple name="forum_subs">
 <li><a href="forum?forum_id=@forum_subs.forum_id@">@forum_subs.name@</a> [<a href="forum-unsubscribe?forum_id=@forum_subs.forum_id@&sub_page=t">Unsubscribe</a>]
</multiple>
</if>
<else>
<i>No Bboard Email Alerts</i>
</else>

</ul>

<h4>Categories</h4>

<ul>

<if @category_subs:rowcount@ gt 0>
<multiple name="category_subs">
 <li><a href="forum-by-category?forum_id=@category_subs.forum_id@&category_id=@category_subs.category_id@">@category_subs.name@</a> [<a href="category-unsubscribe?category_id=@category_subs.category_id@&sub_page=t">Unsubscribe</a>]
</multiple>
</if>
<else>
<i>No Category Email Alerts</i>
</else>
</ul>

<h4>Individual Threads</h4>

<ul>

<if @thread_subs:rowcount@ gt 0>
<multiple name="thread_subs">
 <li><a href="<%= [bboard_message_url @thread_subs.thread_id@ @thread_subs.forum_id@]%>">@thread_subs.name@</a> [<a href="message-unsubscribe?forum_id=@thread_subs.forum_id@&message_id=@thread_subs.thread_id@&sub_page=t">Unsubscribe</a>]
</multiple>
</if>
<else>
<i>No Thread Email Alerts</i>
</else>

</ul>

<p />

Add email alerts from within particular <a href="./">bboards</a>.
