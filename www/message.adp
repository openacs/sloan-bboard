<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@forum_name@: @message.title@</property>

<table width="100%"><tr><td>
<if @admin_p@ not nil and @admin_p@ ne "f">
  [<a href="message-delete?forum_id=@forum_id@&message_id=@message_id@&replies=t">Delete Thread</a>]
</if>

<if @moderate_p@ not nil and @moderate_p@ ne "f">
  [<a href="message-move?forum_id=@forum_id@&message_id=@message_id@">Move Thread</a>]
</if></td>
<td align="right"> <if @subscribed_p@ eq 0>
  [<a href="message-subscribe?forum_id=@forum_id@&message_id=@message_id@">Subscribe to replies</a>]
 </if>
 <else>
  You're subscribed to replies [<a href="message-unsubscribe?forum_id=@forum_id@&message_id=@message_id@">Unsubscribe</a>]
 </else>
</td></tr></table>


<h3>Message:</h3>
<blockquote>
<include src="simple-message-full" title="@message.title@" author="@message.full_name@"
         mime_type="@message.mime_type@" content="@message.content@"
         date="@message.pretty_date@" id="@message.message_id@"
	 write_p="@message.write_p@" admin_p="@admin_p@"
         forum_id="@forum_id@" user_id="@message.user_id@" reply_p="1">
</blockquote>
<if @replies:rowcount@ gt 0>
 <h3>Replies:</h3>
<% set prev_depth 0 %>
 <multiple name=replies>
<%
if {$replies(thread_depth) > $prev_depth} {
        template::adp_puts "<blockquote>"
}
if {$replies(thread_depth) < $prev_depth} {
        for {set i $prev_depth} {$i > $replies(thread_depth)} {incr i -1} {
                template::adp_puts "</blockquote>"
        }
}
set prev_depth $replies(thread_depth)
%>
  <a name="@replies.message_id@">
  <include src="simple-message-@presentation@" title="@replies.title@" author="@replies.full_name@"
           mime_type="@replies.mime_type@" content="@replies.content@"
	   date="@replies.pretty_date@" id="@replies.message_id@" 
 	   write_p="@replies.write_p@" admin_p="@admin_p@"
           forum_id="@forum_id@" user_id=@replies.user_id@ reply_p=@replies_p@>
  <if @replies:rowcount@ ne @replies.rownum@>
  <include src="simple-message-separator-@presentation@">
  </if>
 </multiple>
<%
# We have to close the blockquotes (ben)
for {set i $prev_depth} {$i > 0} {incr i -1} {
        template::adp_puts "</blockquote>"
}
%>
</if>

 <center><form action="message-new">
  <input type="hidden" name="forum_id" value="@forum_id@">
  <input type="hidden" name="reply_to" value="@message_id@">
  <input type="submit" value="Post a reply">
 </form></center>

