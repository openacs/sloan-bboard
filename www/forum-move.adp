<%

    #
    #  Copyright (C) 2001, 2002 OpenForce, Inc.
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<master src="master">
<property name="title">Move a forum's messages</property>
<property name="context_bar">Move</property>

<form action="forum-move-2" method="POST">
 @form_data@

<blockquote> <table>

<tr><th>Forum:</th><td>@forum_name@</td></tr>
<tr><th>Charter:</th>
 <td valign="top">
 @charter@</td>
</tr></table>
 <p>

Move to this forum's messages to: <select name="dest_forum_id">
	  <multiple name="forums">
	    <option value="@forums.forum_id@">@forums.short_name@</option>
	  </multiple>
	</select> forum?
<br>
This will <strong>move all of this forum's messages and categories</strong> and is not easily undoable.


 <blockquote><input type="submit" value="Confirm"></blockquote>
 </blockquote>
</form>
