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
    
    A form for editing a message

    @author John Prevost <jmp@arsdigita.com>
    @creation-datee 2000-09-08
    @cvs $Id$

    @param message_id The message to edit

} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
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
    msg_mime_type:onevalue
}

ad_require_permission $message_id bboard_write_message

db_1row message_info {
    select message_id, reply_to, title, mime_type, content
        from acs_messages_all m
        where message_id = :message_id
}

set msg_mime_type $mime_type

set category_id ""

db_0or1row first_category {
    select min(category_id) as category_id from bboard_category_message_map
        where message_id = :message_id
        group by message_id
}

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set page_title "Edit a Message in $forum_name"

set target "message-edit-2"
set submit_label "Confirm Changes"

set context_bar \
	[list [list "forum?[export_url_vars forum_id]" $forum_name] \
              "Edit a Message"]

set user_id [ad_conn user_id]

set category_pulldown_list ""

db_0or1row quote_info {
    select m.reply_to, m.title, m.sent_date,
           m.mime_type, m.content, 
           p.first_names||' '||p.last_name as full_name
      from acs_messages_all m, persons p
      where message_id = :reply_to
        and person_id = sender
} -column_array quote

db_multirow categories category_list {
    select c.category_id, c.short_name
      from bboard_categories c
      where forum_id = :forum_id
}

ad_return_template "message-entry"
