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

    Displays a list of messages in a forum

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-08-29
    @cvs-id $Id$
} {
    forum_id:integer,notnull
    {last_n_days:integer,optional ""}
} -properties {
    forum_write_p:onevalue
    forum_create_p:onevalue
    context_bar:onevalue
    title:onevalue
    forum_name:onevalue
    forum_id:onevalue
    messages:multirow
    categories:multirow
    moderator_p:onevalue
    unapproved:multirow
    rejected:multirow
    subscribed_p:onevalue
    last_n_days:onevalue
    uncategorized_count:onevalue
}

set user_id [ad_verify_and_get_user_id]
set package_id [ad_conn package_id]

ad_require_permission $forum_id bboard_read_forum

db_1row forum_info {
    select short_name as forum_name, moderated_p,
       acs_permission.permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission.permission_p(:forum_id, :user_id, 'bboard_create_category') 
          as category_create_p
      from bboard_forums
     where forum_id = :forum_id
     and bboard_id= :package_id
}

set moderator_p 0

if [string equal $moderated_p "t"] {
    set moderator_p [ad_permission_p $forum_id bboard_moderate_forum]
}


if [string equal [bboard_forum_subscribed_p $user_id $forum_id] "t"] {
    set subscribed_p 1
} else {
    set subscribed_p 0
}

if [string equal $last_n_days ""] {
    set last_n_days [ad_parameter DisplayLastNDays]
    
    if [string equal $last_n_days ""] {
	set last_n_days "0"
    }
}

set context_bar [list $forum_name]
set title $forum_name

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

if [string equal $moderated_p "f"] {

    db_multirow messages messages_select {
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name,
	       to_char(last_reply_date,'MM/DD/YY hh12:Mi am') as last_updated,
               bboard_message.new_p(message_id, :user_id) as new_p
          from bboard_messages_all b, persons
          where forum_id = :forum_id
	    and sent_date > decode(:last_n_days, 0, '1976-01-01', sysdate - :last_n_days)
	    and person_id = sender
            and reply_to is null
	order by sent_date desc
    }

    db_multirow categories categories_select {
 	select c.category_id, short_name, count(m.message_id) as message_count
	  from bboard_categories c,
	       bboard_category_message_map m
	  where c.forum_id = :forum_id
            and m.category_id(+) = c.category_id
	    and (m.message_id is null 
                or m.message_id in (select f.message_id
                                     from bboard_forum_message_map f
                                     where f.forum_id = :forum_id))
	  group by c.category_id, short_name
    }

    db_1row uncategorized_count {
	select count(*) as uncategorized_count
            from bboard_messages_by_category b
	    where category_id is null
	          and forum_id = :forum_id
    }


} else {

    db_multirow messages messages_select_approved {
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name,
	       to_char(last_reply_date,'MM/DD/YY hh12:Mi am') as last_updated
          from bboard_messages_all b, persons
          where forum_id = :forum_id
	    and sent_date > decode(:last_n_days, 0, '1976-01-01', sysdate - :last_n_days)
	    and person_id = sender
            and reply_to is null
	    and status = 'approved'
	order by sent_date desc
    }

    db_multirow categories categories_select_approved {
	select c.category_id, c.short_name,
             count(m.message_id) as message_count
	  from bboard_categories c,
	       (select c.category_id, c.message_id
	          from bboard_category_message_map c,
	               bboard_forum_message_map f
	          where c.message_id = f.message_id
                    and f.status = 'approved'
                    and f.forum_id = :forum_id) m
	  where c.forum_id = :forum_id
            and m.category_id(+) = c.category_id
	    and (m.message_id is null 
                or m.message_id in (select f.message_id
                                     from bboard_forum_message_map f
                                     where f.forum_id = :forum_id))
	  group by c.category_id, short_name
    }

    db_1row uncategorized_approved_count {
	select count(*) as uncategorized_count
            from bboard_messages_by_category b
	    where category_id is null
	          and forum_id = :forum_id
    }

}

if { !$moderator_p } {

    db_multirow unapproved unapproved_none {
	select 1 from dual where 1 = 0
    }

    db_multirow rejected rejected_none {
	select 1 from dual where 1 = 0
    }

} else {

    db_multirow unapproved messages_select_unmoderated {
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_all, persons
	  where forum_id = :forum_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'unmoderated'
    }

    db_multirow rejected rejected_messages_select {
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_all, persons
	  where forum_id = :forum_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'rejected'
    }

}

ad_return_template "forum-view"
