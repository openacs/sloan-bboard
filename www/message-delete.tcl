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

    Displays a confirmation of "do you really want to delete this message?"

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-09-06
    @cvs-id $Id$

} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
    {replies ""}
} -properties {
    context_bar:onevalue
    message_id:onevalue
    forum_id:onevalue
    message:onerow
    replies:onevalue
}

if {[ad_parameter "UserPostsDeletableP"] == "t"} {
    ad_require_permission $message_id bboard_write_message
} else {
    ad_require_permission $message_id admin
}

if ![db_0or1row message_info {
        select m.message_id, m.reply_to, m.title,
               m.sent_date, m.mime_type, m.content, 
               p.first_names ||' '||p.last_name as full_name
            from acs_messages_all m, persons p, bboard_forum_message_map f
            where m.message_id = :message_id
                and f.message_id = :message_id
                and f.forum_id = :forum_id
                and p.person_id = m.sender
    } -column_array message] {
    # It's not in that forum!
    ad_returnredirect "forum?forum_id=$forum_id"
    ad_script_abort
}

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set context_bar [list [list "forum?[export_url_vars forum_id]" $forum_name] \
		      {"Delete Message"}]

ad_return_template
