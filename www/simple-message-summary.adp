<% # A simple single message summary
   # This should, in the future, use a row variable rather than many
   # single values, but row variables are not yet supported. %>

<%
for {set i 0} {$i < $thread_depth} {incr i} {
        template::adp_puts "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
}
%>
<a href=message?message_id=@id@&forum_id=@forum_id@>@title@</a> by <A href=>@author@</a> on @date@
