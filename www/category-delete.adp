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
<property name="title">Delete a Category</property>

You are going to delete the category "@category_name@", causing all
@message_count@ messages in it to be placed in the category "Unknown".

<center>
<p>Are you sure you want to delete this category?<p>

<a href="category-delete-2?category_id=@category_id@">Yes</a> &nbsp; &nbsp;
<a href="<%= [get_referrer_and_query_string] %>">No</a>
</center>
