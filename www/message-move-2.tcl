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
    
    Moves a message or thread to another forum.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2001-02-20
    @cvs-id $Id$

} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
    dest_forum_id:integer,notnull,bboard_forum_id
} 

ad_require_permission $forum_id admin
ad_require_permission $dest_forum_id admin

set user_id [ad_conn user_id]

db_transaction {
    db_dml update_bboard_contexts {
	update acs_objects
	    set context_id = :dest_forum_id
	    where context_id = :forum_id
	          and object_type = 'acs_message'
                  and object_id in (select message_id
                                        from acs_messages m
                                        connect by prior message_id = reply_to
                                        start with message_id = :message_id) 
    }

    db_dml move_bboard_messages {
        update bboard_forum_message_map 
            set forum_id = :dest_forum_id
            where forum_id = :forum_id
                  and message_id in (select message_id
                                         from acs_messages m
                                         connect by prior message_id = reply_to
                                         start with message_id = :message_id) 
    }

}

ad_returnredirect "forum?forum_id=$forum_id"
