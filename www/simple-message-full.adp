<% # A simple single message
   # This should, in the future, use a row variable rather than many
   # single values, but row variables are not yet supported. %>

<%
   # The first table is just for thread spacing purposes
   # (ben)
%>

<%
if {$new_p == "t"} {
        set title "$title (NEW!)"
}
%>

<table border=0 width=100%>
<tr>
<td>
<%
if {[info exists thread_depth]} {
        for {set i 0} {$i < $thread_depth} {incr i} {
                template::adp_puts "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        }
}
%>
</td>
<td>

<table cellspacing="0" cellpadding="3" border="0" width="90%">
 <tr bgcolor="#ECECEC">
  <if @headings_p@ not nil and @headings_p@ ne "f">
   <th width="15%" align="left" valign="top">Subject:</th>
  </if>
  <td align="left">
   <if @id@ not nil and @link_p@ not nil and @link_p@ ne "f">
    <b><i><a href="<%=[bboard_message_url @id@ @forum_id@]%>">@title@</a></i></b>
   </if>
   <else>
    <b><i>@title@</i>
</b>
   </else>
   &nbsp;
  </td>
   <if @id@ not nil>
    <td align="right">
     <if @write_p@ not nil and @write_p@ ne "f">
      [<a href="message-edit?forum_id=@forum_id@&message_id=@id@">edit</a>]
      <if @attachments_p@ not nil and @attachments_p@ ne "f">
       [<a href="message-attach?forum_id=@forum_id@&message_id=@id@">attach file</a>]
      </if>
     </if>
     <if @delete_p@ not nil and @delete_p@ ne "f">
      [<a href="message-delete?forum_id=@forum_id@&message_id=@id@">delete</a>]
     </if>
     <if @mail_friend_p@ not nil and @mail_friend_p@ ne "f">
      [<a href="message-mail?forum_id=@forum_id@&message_id=@id@">email</a>]
     </if>
     <if @reply_p@ not nil and @reply_p@ ne "f">
      [<a href="message-new?forum_id=@forum_id@&reply_to=@id@">reply</a>]
     </if>
    </td>
   </if>
  </tr>
<tr>
 <if @headings_p@ not nil and @headings_p@ ne "f">
  <th width="15%" align="left" valign="top">Message:</th>
 </if>
 <td colspan="2" align="left"><br /><%= @formatted_content@ %></td>
</tr>

<if @author@ not nil and @date@ not nil>
 <tr><td colspan="2">&nbsp;</td></tr>
 <tr>
  <if @headings_p@ not nil and @headings_p@ ne "f">
   <td></td>
  </if>
  <td colspan="2" align="right">
   <if @user_id@ not nil and @id@ not nil>
   -- <a href="messages-by-user?forum_id=@forum_id@&user_id=@user_id@">@author@</a>, @date@
   </if>
   <else>
   -- @author@, @date@
   </else>
  </td></tr>
</if>

<if @display_attach_p@ nil or @display_attach_p@ ne "f">
 <if @id@ not nil and @attachments_p@ not nil and @attachments_p@ ne "f"> 
  <if @attachments:rowcount@ gt 0>
  <tr><td><i>Attachment:</i> 
   <multiple name="attachments">
    <a href="attachment?file_id=@attachments.file_id@">@attachments.name@</a> - @attachments.title@
    <if @write_p@ not nil and @write_p@ ne "f">
     [<a href="attachment-delete?file_id=@attachments.file_id@&message_id=@id@">delete</a>] 
    </if><br />
   </multiple></td></tr>
  </if>
 </if>
</if>
</table>

</td>
</tr>
</table>
