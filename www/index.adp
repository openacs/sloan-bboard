<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">@bboard_forum_name_plural@</property>

[<a href="subscriptions">Manage My Email Alerts</a>]

<if @forums:rowcount@ eq 0>
 <p><i>There are no @bboard_forum_name_plural@ available.</i><p>
</if>

<else>
 <ul>
  <multiple name=forums>
   <li><a href="forum?forum_id=@forums.forum_id@">@forums.short_name@</a>
    <if @forums.moderated_p@ eq "t">
     (moderated)
    </if>
    <if @admin_p@ ne "0">
     [<a href="forum-edit?forum_id=@forums.forum_id@">edit</a>]
    </if>
    <if @forums.charter@ ne "">
    <br />
    @forums.charter@
    <br />
    </if>
   </li>
  </multiple>
 </ul>
</else>

<p />

<if @admin_p@ ne 0>
 [<a href="forum-new">Create a @bboard_forum_name@</a>]
<!-- [<a href="/permissions/one?object_id=@package_id@">Admin Permissions</a>] -->
</if>
<p>
