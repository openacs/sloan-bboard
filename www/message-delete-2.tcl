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

    Delete a message

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-09-06
    @cvs-id $Id$

} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
    {replies ""}
}

if {[ad_parameter "UserPostsDeletableP"] == "t"} {
    ad_require_permission $message_id bboard_write_message
} else {
    ad_require_permission $message_id admin
}

set user_id [ad_conn user_id]

if [string eq $replies ""] {
    bboard_message_set_status -message_id $message_id -forum_id $forum_id \
	    -status [db_null]
} else {
    db_dml bboard_delete_threads {
	delete from bboard_forum_message_map bfm
	    where message_id in (select message_id
                                     from acs_messages m
                                     connect by prior message_id = reply_to
                                     start with message_id = :message_id)
                  and exists (select 1 from acs_object_party_privilege_map
                                  where object_id = bfm.message_id
                                        and party_id in (:user_id, -1)
                                        and privilege = 'bboard_delete_message')

    }
}

ad_returnredirect "forum?forum_id=$forum_id"
