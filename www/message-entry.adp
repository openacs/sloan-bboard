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
 <input type="hidden" name="forum_id" value="@forum_id@">
 <input type="hidden" name="reply_to" value="@reply_to@">
 <if @message_id@ not nil>
  <input type="hidden" name="message_id" value="@message_id@">
 </if>
 <blockquote>
  <table>
   <if @quote.title@ not nil>
    <tr>
     <th align="right" valign="top">In Reply To:</td>
     <td>
      <include src="simple-message-full" title="@quote.title@" author="@quote.full_name@"
               date="@quote.sent_date@" mime_type="@quote.mime_type@" forum_id="@forum_id@"
	       content="@quote.content@" display_attach_p="f">
      <br />
     </td>
    </tr>
   </if>
   <tr>
    <th align="right">Subject:</th>
    <td><input size="50" name="title" value="@title@"></td>
   </tr>
   <tr>
    <th align="right">Category:</th>
    <td>
      <select name="category_id">
        <option value="">Unknown</option>
	<multiple name="categories">
	 <if @category_id@ eq @categories.category_id@>
	  <option value="@categories.category_id@" selected>@categories.short_name@</option>
	 </if>
	 <else>
	  <option value="@categories.category_id@">@categories.short_name@</option>
	 </else>
	</multiple>
      </select>
    </td>
   </tr>
   <tr valign="top">
    <th align="right"><br>Message:</td>
    <td><textarea name="content" rows="20" cols="50" wrap><%= [ns_quotehtml $content] %></textarea></td>
   </tr>
   <tr>
    <th align="right">Text type?</th>
    <td>
     <select name="mime_type">
      <option value="text/plain; format=flowed" <if @msg_mime_type@ nil or @msg_mime_type@ eq "text/plain; format=flowed">selected</if>>Plain</option>
      <option value="text/plain" <if @msg_mime_type@ not nil and @msg_mime_type@ eq "text/plain">selected</if>>Preformatted</option>
      <option value="text/html" <if @msg_mime_type@ not nil and @msg_mime_type@ eq "text/html">selected</if>>HTML</option>
     </select>
    </td>
   </tr>
   <tr>
    <th></th>
    <td><input type="submit" value="@submit_label@"></td>
  </table>
 </blockquote>
</form>
