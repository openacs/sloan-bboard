<master src="master">
<property name="title">@forum_name@: @title@</property>
<property name="context_bar">@context_bar@</property>

<form action="@action@" method="POST">
 <input type="hidden" name="forum_id" value="@forum_id@">
 <input type="hidden" name="category_id" value="@category_id@">
 <blockquote>
  <table>
   <tr>
    <th align="right">Short Name:</th>
    <td><input size="50" name="short_name" value="@short_name@"></td>
   </tr>
   <tr>
    <th></th>
    <td><input type="submit" value="@submit_label@"></td>
  </table>
 </blockquote>
</form>

