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
<property name="title">@forum_name@: @title@</property>
<property name="context_bar">@context_bar@</property>

<form action="@action@" method="POST">
 <input type="hidden" name="forum_id" value="@forum_id@">
 <input type="hidden" name="category_id" value="@category_id@">
 <blockquote>
  <table>
   <tr>
    <th align="right">Short Name:</th>
    <td><input size="50" name="short_name" value="@short_name@"></td>
   </tr>
   <tr>
    <th></th>
    <td><input type="submit" value="@submit_label@"></td>
  </table>
 </blockquote>
</form>

