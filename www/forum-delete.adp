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
<property name="title">@forum_name@</property>

<h3>Delete @forum_name@ forum?</h3>

You have chosen to delete the @forum_name@ forum.<p>  This forum and its
messages (@message_count@) will be <strong>irrevocably deleted</strong>.<p>

<form method="post" action="forum-delete-2">
<input type="hidden" name="forum_id" value="@forum_id@">
<input type="submit" value="Delete Forum">
</form>

