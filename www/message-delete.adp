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
<property name="title">Delete a Message</property>

<include src="simple-message" title="@message.title@" author="@message.full_name@"
	 mime_type="@message.mime_type@" content="@message.content@"
	 date="@message.sent_date@" id="@message.message_id@"
	 link_p="f" forum_id="@forum_id@">

<center>

<if @replies@ ne "t">
<p>Are you sure you want to delete this message?<p>

<a href="message-delete-2?forum_id=@forum_id@&message_id=@message_id@">Yes</a>
</if>
<else>
<p>Are you sure you want to delete this message and all of its replies?<p>

<a href="message-delete-2?forum_id=@forum_id@&message_id=@message_id@&replies=t">Yes</a> &nbsp; &nbsp;
</else>
&nbsp; &nbsp;
<a href="<%= [get_referrer_and_query_string] %>">No</a>
</center>
