<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">Forums</property>

[<a href="subscriptions">Manage Subscriptions</a>]

<if @forums:rowcount@ eq 0>
 <i>There are no forums available.</i><p>
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
     [<a href="forum-delete?forum_id=@forums.forum_id@">delete</a>]
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
 [<a href="forum-new">Create a forum</a>]
 [<a href="/admin/site-map/parameter-set?package_id=@package_id@">Set Parameters</a>] 
 [<a href="/permissions/one?object_id=@package_id@">Admin Permissions</a>]
</if>
<p>
