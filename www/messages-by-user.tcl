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

    Displays a given user's posting history.

    @author Anukul Kapoor
    @creation-date 2000-11-22
    @cvs-id $Id$

} {
    user_id:integer,notnull
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    context_bar:onevalue
    title:onevalue
    forum_name:onevalue
    forum_id:onevalue
    messages:multirow
}

set current_user_id [ad_verify_and_get_user_id]

ad_require_permission $forum_id bboard_read_forum

db_1row user_info {
    select first_names||' '||last_name as full_name
      from persons
      where person_id = :user_id
}

db_1row forum_info {
    select short_name as forum_name, moderated_p from bboard_forums
      where forum_id = :forum_id
}

if [string equal $moderated_p f] {

    db_multirow messages messages_select {
        select title, num_replies, message_id,
               first_names||' '||last_name as full_name
        from bboard_messages_all, persons
        where sender = :user_id
              and forum_id = :forum_id
              and person_id = sender
    }
} else {
    db_multirow messages messages_select {
        select title, num_replies, message_id,
               first_names||' '||last_name as full_name
        from bboard_messages_all, persons
        where sender = :user_id
              and forum_id = :forum_id
              and person_id = sender
              and status = 'approved'
    }
}


set package_id [ad_conn package_id]

db_multirow alt_forums alt_forums_select {
    select forum_id, short_name
    from bboard_forums bf
    where not forum_id = :forum_id
          and bboard_id = :package_id
          and exists (select 1
                      from bboard_messages_all bma
                      where sender = :user_id 
                            and bma.forum_id = bf.forum_id)
          and exists (select 1 from acs_object_party_privilege_map
                          where object_id = bf.forum_id
                            and party_id in (:current_user_id, -1)
                            and privilege = 'bboard_read_forum')
}

set title "Posting History for $full_name in $forum_name"

set context_bar [list $forum_name]
 
ad_return_template
