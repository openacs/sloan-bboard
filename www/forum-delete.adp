<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@forum_name@</property>

<h3>Delete @forum_name@ forum?</h3>

You have chosen to delete the @forum_name@ forum.<p>  This forum and its
messages (@message_count@) will be <strong>irrevocably deleted</strong>.<p>

<form method="post" action="forum-delete-2">
<input type="hidden" name="forum_id" value="@forum_id@">
<input type="submit" value="Delete Forum">
</form>

