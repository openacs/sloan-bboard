<master src="master">
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<form action="@target@" method="POST">
 @form_vars@
 <include src="simple-message" title="@title@" headings_p="t"
          content="@content@" mime_type="@msg_mime_type@">
 <br>
 <blockquote><input type="submit" value="Confirm">
 <if @subscribe_p@ not nil and @subscribe_p@ eq 1>
  &nbsp; <input type="checkbox" name="subscribe_p"> Subscribe to replies
 </if></blockquote>
</form>
