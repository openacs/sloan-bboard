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
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>

<form enctype="multipart/form-data" method=POST action="message-attach-2">
<%= [export_form_vars file_id message_id] %>

<blockquote>
<table>
  <tr>
    <td valign="top" align="right">Title:</td>
    <td><input size="40" name="file_title" value=""></td>
  </tr>
  <tr>
    <td valign="top" align="right">Filename: </td>
    <td>
     <input type="file" name="upload_file" size="40"><br>
     <span class="note">Use the "Browse..." button to locate your file, then click "Open".</span>
    </td>
  </tr>
</table>
</blockquote>

<p>
<center>
<input type=submit value="Proceed">
</center>
</form>
