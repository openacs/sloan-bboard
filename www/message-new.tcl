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

ad_page_contract {
    
    A form for posting a new message to a bboard forum.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-datee 2000-08-29
    @cvs $Id$

    @param forum_id    The forum to post in
    @param category_id The default category for the message
    @param reply_to    The message this post should be in reply to

} {
    forum_id:integer,notnull,bboard_forum_id
    {category_id:integer,bboard_category_id ""}
    {reply_to:integer,acs_message_id ""}
} -properties { 
    context_bar:onevalue
    forum_id:onevalue
    forum_name:onevalue
    categories:multirow
    category_id:onevalue
    reply_to:onevalue
    quote:onerow
    has_quote:onevalue
    page_title:onevalue
    target:onevalue
    title:onevalue
    content:onevalue
    submit_label:onevalue
    message_id:onevalue
}

ad_require_permission $forum_id bboard_create_message

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set page_title "Post a New Message to $forum_name"

set target "message-new-2"
set submit_label "Post Message"

set title ""
set content ""

set context_bar \
	[list [list "forum?[export_url_vars forum_id]" $forum_name] \
              "Post"]

set user_id [ad_verify_and_get_user_id]

set category_pulldown_list ""

db_0or1row quote_info {
    select reply_to, title, sent_date,
           mime_type, content, 
           first_names||' '||last_name as full_name
      from acs_messages_all m, persons p
      where message_id = :reply_to
        and person_id = sender
} -column_array quote

if ![empty_string_p $reply_to] {
    if [string equal -length 4 -nocase "Re: " $quote(title)] {
        set title $quote(title)
    } else {
        set title "Re: $quote(title)"
    }
}

db_0or1row quote_first_category {
    select min(category_id) as category_id from bboard_category_message_map
      where message_id = :reply_to
      group by message_id
}

db_multirow categories category_list {
    select category_id, short_name
      from bboard_categories
      where forum_id = :forum_id
}

ad_return_template "message-entry"
