ad_page_contract {
    Presents confirmation screen for deleting a forum.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-date 2000-30-11
    @cvs-id $Id$
} {
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    forum_id:onevalue
    short_name:onevalue
    charter:onevalue
}

set package_id [ad_conn package_id]

set context_bar {}
set user_id [ad_verify_and_get_user_id]

ad_require_permission $forum_id admin

db_1row forum_info {
    select short_name as forum_name, charter as forum_charter
    from bboard_forums
    where forum_id = :forum_id
}

db_1row forum_message_count {
    select count(*) as message_count
    from bboard_forum_message_map bfmm
    where bfmm.forum_id = :forum_id
}

ad_return_template