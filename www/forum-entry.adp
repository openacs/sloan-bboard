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

<form action="@action@" method="POST">
 <input type="hidden" name="forum_id" value="@forum_id@">
 <blockquote>
  <table>
   <tr>
    <th align="right">Short Name:</th>
    <td><input size="50" name="short_name" value="@short_name@"></td>
   </tr>
   <tr>
    <th align="right"><%= [bboard_forum_name] %> Type:</th>
    <td><SELECT name=forum_type>
        <OPTION value=q-and-a>Q &amp; A
        <OPTION value=thread>Threaded
        </SELECT>
    </td>
   <!--<tr valign="top">
    <th align="right"><br>Charter (optional):</td>
    <td><textarea name="charter" rows="20" cols="50"><%= [ns_quotehtml $charter] %></textarea></td>
   </tr>-->
   <!--<tr>
    <th align="right">Moderated:</td>
    <if @moderated_p@ eq "t">
     <td><input type="checkbox" name="moderated_p" checked></td>
    </if>
    <else>
     <td><input type="checkbox" name="moderated_p"></td>
    </else>
   </tr>-->
   <tr>
    <th></th>
    <td><input type="submit" value="@submit_label@"></td>
  </table>
 </blockquote>
</form>

<if @extra_footer@ not nil>@extra_footer@</if>
