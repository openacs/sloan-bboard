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
<property name="title">@forum_name@: @title@</property>

<table width="100%"><tr><td>
<if @moderate_p@ not nil and @moderate_p@ ne "f">
  [<a href="message-move?forum_id=@forum_id@&message_id=@message_id@">Move Thread</a>]
</if></td>

<td align="right"> 
<if @subscribed_p@ eq 0>
  [<a href="message-subscribe?forum_id=@forum_id@&message_id=@message_id@">Subscribe to replies</a>]
 </if>
 <else>
  You're subscribed to replies [<a href="message-unsubscribe?forum_id=@forum_id@&message_id=@message_id@">Unsubscribe</a>]
 </else>
</td></tr></table><p>

<table width="100%">
 <multiple name=messages>
  <tr><td><img src="spacer.gif" width="<%= [expr 25*@messages.thread_depth@]%>" 
               align="left">
  <a name="@messages.message_id@">
  <include src="simple-message" title="@messages.title@" author="@messages.full_name@"
           mime_type="@messages.mime_type@" content="@messages.content@"
	   date="@messages.pretty_date@" id="@messages.message_id@" link_p="t"
 	   write_p="@messages.write_p@"
           reply_p="t" forum_id="@forum_id@"
	   admin_p="@admin_p@" user_id="@messages.user_id@">
  </tr></td>
 </multiple>
</table>

