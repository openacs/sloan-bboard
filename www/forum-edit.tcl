ad_page_contract {

    Displays a form for editing a forum.

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-09-07
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    context_bar:onevalue
    forum_id:onevalue
    title:onevalue
    action:onevalue
    submit_label:onevalue
    short_name:onevalue
    charter:onevalue
    moderated_p:onevalue
}

ad_require_permission $forum_id admin

db_1row forum_info {
    select short_name, charter, moderated_p from bboard_forums
      where forum_id = :forum_id
}

set bboard_forum_name [bboard_forum_name]

set context_bar [list "Edit a $bboard_forum_name"]
set title "Edit a $bboard_forum_name"
set action "forum-edit-2"
set submit_label "Save Changes"

ad_return_template "forum-entry"
