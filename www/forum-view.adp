<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@title@</property>

<table width="100%" cellspacing="0" cellpadding="0"><tr><td>
 <if @category_id@ not nil>
  [ <b><a href="message-new?forum_id=@forum_id@&category_id=@category_id@">Post a message</a></b> ]
 </if>
 <else>
  [<b><a href="message-new?forum_id=@forum_id@">Post a message</a></b>]
 </else>

</if>
</td>

<td align="right">
 <if @subscribed_p@ eq 0>
  <if @category_id@ not nil>
   [<a href="category-subscribe?category_id=@category_id@">Add Alert for this Category</a>]
  </if>
  <else>
   [<a href="forum-subscribe?forum_id=@forum_id@">Add Alert for this <%= [bboard_forum_name] %></a>]
  </else>
 </if>
 <else>
  <if @category_id@ not nil>
   You're subscribed to this category [<a href="category-unsubscribe?category_id=@category_id@">Remove Alert</a>]
  </if>
  <else>
   You're subscribed to this <%= [bboard_forum_name] %> [<a href="forum-unsubscribe?forum_id=@forum_id@">Remove Alert</a>]
  </else>
 </else>
</td>
</tr></table><p>

<table width="100%" cellspacing="0" cellpadding="0"><tr><td>
<h3>Messages</h3><td>

 <if @last_n_days@ not nil and @last_n_days@ ne 0>
 <td align="right"> Last @last_n_days@ days.  <a href="forum?forum_id=@forum_id@&last_n_days=0">Show All Messages</a>.</td>
 </if>
</tr></table>

<if @moderator_p@ ne 0>
 <if @unapproved:rowcount@ gt 0>
  <h4>Not Yet Approved</h4>
  <ul>
   <multiple name=unapproved>
    <li><a href="<%=[bboard_message_page]%>?forum_id=@forum_id@&message_id=@unapproved.message_id@">@unapproved.title@</a>
     (@unapproved.num_replies@)  &nbsp; @unapproved.full_name@
     [<a href="message-approve?forum_id=@forum_id@&message_id=@unapproved.message_id@">approve</a>]
     [<a href="message-reject?forum_id=@forum_id@&message_id=@unapproved.message_id@">reject</a>]
    </li>   
   </multiple>
  </ul>
  <h4>Approved</h4>
 </if>
</if>

<include src="message-list" &=messages forum_id="@forum_id@" last_updated_p="t" top_p="t"/>

<if @moderator_p@ ne 0>
 <if @rejected:rowcount@ gt 0>
  <h4>Rejected</h4>
  <ul>
   <multiple name=rejected>
    <li><a href="<%=[bboard_message_page]%>?forum_id=@forum_id@&message_id=@rejected.message_id@">@rejected.title@</a>
     (@rejected.num_replies@) &nbsp; @rejected.full_name@
    </li>   
   </multiple>
  </ul>
 </if>
</if>

<if @categories:rowcount@ ne 0 or @category_create_p@ ne 0>
 <h3>By Category</h3>
</if>
<if @categories:rowcount@ ne 0>
 <ul>
  <multiple name=categories>
   <li><a href="forum-by-category?forum_id=@forum_id@&category_id=@categories.category_id@">@categories.short_name@</a>
    (@categories.message_count@)
    <if @admin_p@ eq "t">
     [<a href="category-edit?category_id=@categories.category_id@">edit</a>]
     [<a href="category-delete?category_id=@categories.category_id@">delete</a>]
    </if>
   </li>
  </multiple>
  <li><a href="forum-by-category?forum_id=@forum_id@&category_id=">Uncategorized</a>(@uncategorized_count@)</li>
 </ul>
</if>

<if @category_create_p@ ne 0>
 [<a href="category-new?forum_id=@forum_id@">Create a category</a>]
</if> <p>

<h3>Search</h3>
<form method="get" action="search">
 <input type="hidden" name="forum_id" value="@forum_id@">
 <input type="text" name="query"> 
 <input type="submit" value="Go!">
</form>

<p>

<if @admin_p@ eq "t">
 <h3>Admin</h3>
 [<a href="forum-move?forum_id=@forum_id@">Move messages to other <%= [bboard_forum_name] %></a>]
 [<a href="/permissions/one?object_id=@forum_id@">Set Permissions</a>]
</if>
