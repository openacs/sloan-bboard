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
