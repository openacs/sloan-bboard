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
<property name="title">Mail to a friend</property>
<property name="context_bar">@context_bar@</property>

<form action="message-mail-2" method="POST">
 <input type="hidden" name="forum_id" value="@forum_id@">
 <input type="hidden" name="message_id" value="@message_id@">
 <input type="hidden" name="new_message_id" value="@new_message_id@">
 <blockquote>
  <table>
   <tr>
    <th align="right" valign="top">Forwarding:</td>
    <td>
     <include src="simple-message" author="@quote.full_name@"
              title="\[Fwd by @sender_email@\] @quote.title@"
              date="@quote.sent_date@" mime_type="@quote.mime_type@"
              content="@quote.content@">
    </td>
   </tr>
   <tr>
    <th align="right" valign="center">Recipient Email:</td>
    <td><input type="text" name="email" size="50"></td>
   </tr>
   <tr>
    <th></th>
    <td><input type="submit" value="Send Email"></td>
  </table>
 </blockquote>
</form>
