ad_page_contract {
    
    Displays a form for creating a category in a forum.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-08-31
    @cvs-id $Id$
} {
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    context_bar:onevalue
    forum_name:onevalue
    forum_id:onevalue
    short_name:onevalue
    submit_label:onevalue
    category_id:onevalue
    action:onevalue
    title:onevalue
}

ad_require_permission $forum_id bboard_create_category

set action "category-new-2"
set short_name ""
set submit_label "Create Category"
set title "Create a Category"

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set context_bar \
	[list [list "forum?[export_url_vars forum_id]" $forum_name] \
              "Create a Category"]

set category_id [db_nextval acs_object_id_seq]

ad_return_template category-entry
