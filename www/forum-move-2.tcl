ad_page_contract {
    
    Move a forum's messages to another forum.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2001-04-12
    @cvs-id $Id$

} {
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
	          and (object_type = 'acs_message' or
                       object_type = 'bboard_category')
    }

    db_dml move_bboard_messages {
        update bboard_forum_message_map 
            set forum_id = :dest_forum_id
            where forum_id = :forum_id
    }

    db_dml move_bboard_categories {
	update bboard_categories
	    set forum_id = :dest_forum_id
            where forum_id = :forum_id
    }
}

ad_returnredirect "forum?forum_id=$forum_id"
