ad_page_contract {

    Displays a form for creating a new forum.

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-08-29
    @cvs-id $Id$
} {
} -properties {
    context_bar:onevalue
    forum_id:onevalue
    title:onevalue
    action:onevalue
    submit_label:onevalue
    short_name:onevalue
    charter:onevalue
}

ad_require_permission [ad_conn package_id] admin

set context_bar {"Create a Forum"}
set title "Create a Forum"
set action "forum-new-2"
set submit_label "Create Forum"
set short_name ""
set charter ""
set moderated_p "f"

set forum_id [db_nextval acs_object_id_seq]

ad_return_template "forum-entry"
