ad_page_contract {
    
    Confirmation screem for moving a forum's messages to another forum.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2001-04-12
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    forum_id:onevalue
    forum_name:onevalue
    charter:onevalue
    forums:multirow
}

ad_require_permission $forum_id admin

set user_id [ad_conn user_id]

db_1row forum_info {
    select short_name as forum_name, charter, moderated_p from bboard_forums
      where forum_id = :forum_id
}

db_multirow forums allowed_target_forums {
    select forum_id, short_name
      from bboard_forums
      where not forum_id = :forum_id
        and exists (select 1 from acs_object_party_privilege_map
                      where object_id = forum_id
                        and party_id in (:user_id, -1)
                        and privilege = 'admin')

}

set form_data [export_form_vars forum_id]

ad_return_template
