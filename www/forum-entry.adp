<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@title@</property>

<form action="@action@" method="POST">
 <input type="hidden" name="forum_id" value="@forum_id@">
 <blockquote>
  <table>
   <tr>
    <th align="right">Short Name:</th>
    <td><input size="50" name="short_name" value="@short_name@"></td>
   </tr>
   <tr>
    <th align="right">Forum Type:</th>
    <td><SELECT name=forum_type>
        <OPTION value=q-and-a>Q &amp; A
        <OPTION value=thread>Threaded
        </SELECT>
    </td>
   <tr valign="top">
    <th align="right"><br>Charter (optional):</td>
    <td><textarea name="charter" rows="20" cols="50"><%= [ns_quotehtml $charter] %></textarea></td>
   </tr>
   <tr>
    <th align="right">Moderated:</td>
    <if @moderated_p@ eq "t">
     <td><input type="checkbox" name="moderated_p" checked></td>
    </if>
    <else>
     <td><input type="checkbox" name="moderated_p"></td>
    </else>
   </tr>
   <tr>
    <th></th>
    <td><input type="submit" value="@submit_label@"></td>
  </table>
 </blockquote>
</form>
