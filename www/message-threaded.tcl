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

    Displays a single message, and all replies in a threaded fashion.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-09-01
    @cvs-id $Id$
} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    context_bar:onevalue
    forum_name:onevalue
    forum_id:onevalue
    message:onerow
    replies:multirow
    title:onevalue
    subscribed_p:onevalue
}

ad_require_permission $message_id bboard_read_forum

set user_id [ad_conn user_id]

if [string equal [bboard_message_subscribed_p -direct $user_id $message_id] "t"] {
    set subscribed_p 1
} else {
    set subscribed_p 0
}

db_1row forum_short_name {
    select short_name as forum_name,
       acs_permission.permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission.permission_p(:forum_id, :user_id, 'bboard_moderate_forum') 
         as moderate_p
      from bboard_forums
      where forum_id = :forum_id
}

db_1row thread_title {
    select title
      from acs_messages_all
      where message_id = :message_id
}

set context_bar [list [list "forum?[export_url_vars forum_id]" $forum_name] \
		      "One Message"]
                   
db_multirow messages messages_and_replies {
  select m.message_id, m.reply_to, m.title, m.sent_date, m.mime_type,
         to_char(m.sent_date, 'Month DD, YYYY HH:Mi am') as pretty_date,
         m.content, p.first_names||' '||p.last_name as full_name, 
         p.person_id as user_id,
         mt.depth - 1 as thread_depth,
      acs_permission.permission_p(m.message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p, 
      (select message_id, level as depth, rownum as seqnum
         from acs_messages
         connect by prior message_id = reply_to
         start with message_id = :message_id) mt
    where p.person_id = m.sender
      and m.message_id = mt.message_id
      and m.message_id in (select bfmm.message_id 
                               from bboard_forum_message_map bfmm
                               where bfmm.forum_id = :forum_id)
      order by seqnum
}

ad_return_template
