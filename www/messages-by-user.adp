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
<property name="context_bar">@context_bar@</property>
<property name="title">@title@</property>


<if @messages:rowcount@ eq 0>
  <i>There are no messages for this user this forum.</i><p>
</if>

<else>
 <include src="message-list" &=messages forum_id="@forum_id@" author_p="0" />
</else>

<p>

Posting History in Other Forums:
<ul>
 <multiple name="alt_forums">
  <li><a href="messages-by-user?forum_id=@alt_forums.forum_id@&user_id=@user_id@">@alt_forums.short_name@</a>
 </multiple>
</ul>
