<master src="master">
<property name="context_bar">Subscriptions</property>
<property name="title">Manage Subscriptions</property>

You have the follow subscriptions:<br>

<h4>Forums</h4>

<ul>

<multiple name="forum_subs">
 <li><a href="forum?forum_id=@forum_subs.forum_id@">@forum_subs.name@</a> [<a href="forum-unsubscribe?forum_id=@forum_subs.forum_id@&sub_page=t">Unsubscribe</a>]
</multiple>

</ul>

<h4>Categories</h4>

<ul>

<multiple name="category_subs">
 <li><a href="forum-by-category?forum_id=@category_subs.forum_id@&category_id=@category_subs.category_id@">@category_subs.name@</a> [<a href="category-unsubscribe?category_id=@category_subs.category_id@&sub_page=t">Unsubscribe</a>]
</multiple>

</ul>

<h4>Individual Threads</h4>

<ul>

<multiple name="thread_subs">
 <li><a href="<%= [bboard_message_url @thread_subs.thread_id@ @thread_subs.forum_id@]%>">@thread_subs.name@</a> [<a href="message-unsubscribe?forum_id=@thread_subs.forum_id@&message_id=@thread_subs.thread_id@&sub_page=t">Unsubscribe</a>]
</multiple>

</ul>

<p />

Add subscriptions from within particular <a href="">forums</a>.