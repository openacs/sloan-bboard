<master src="master">
<property name="title">Move a message</property>
<property name="context_bar">Move</property>

<form action="message-move-2" method="POST">
 @form_data@

 <include src="simple-message" title="@title@" headings_p="t"
          content="@content@" mime_type="@msg_mime_type@">
 <br>

Move to this message and its replies to which forum?<br>
	<select name="dest_forum_id">
	  <multiple name="forums">
	    <option value="@forums.forum_id@">@forums.short_name@</option>
	  </multiple>
	</select>
<br>

 <blockquote><input type="submit" value="Confirm">
 </blockquote>
</form>
