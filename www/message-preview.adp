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
<property name="title">@page_title@</property>
<property name="context_bar">@context_bar@</property>

<form action="@target@" method="POST">
 @form_vars@
 <include src="simple-message-full" title="@title@" headings_p="t"
          content="@content@" mime_type="@msg_mime_type@">
 <br>
 <blockquote><input type="submit" value="Confirm">
 <if @subscribe_p@ not nil and @subscribe_p@ eq 1>
  &nbsp; <input type="checkbox" name="subscribe_p"> Subscribe to replies
 </if></blockquote>
</form>
