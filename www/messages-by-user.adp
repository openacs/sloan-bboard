<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@title@</property>


<if @messages:rowcount@ eq 0>
  <i>There are no messages for this user this forum.</i><p>
</if>

<else>
 <include src="message-list" &=messages forum_id="@forum_id@" author_p="0" />
</else>

<p>

Posting History in Other Forums:
<ul>
 <multiple name="alt_forums">
  <li><a href="messages-by-user?forum_id=@alt_forums.forum_id@&user_id=@user_id@">@alt_forums.short_name@</a>
 </multiple>
</ul>