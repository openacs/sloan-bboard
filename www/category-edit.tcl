ad_page_contract {

    Displays a form for editing a category in a forum.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-09-07
    @cvs-id $Id$

} {
    category_id:integer,notnull,bboard_category_id
} -properties {
    context_bar:onevalue
    forum_name:onevalue
    forum_id:onevalue
    category_id:onevalue
    action:onevalue
    title:onevalue
}

ad_require_permission $category_id bboard_write_category

set action "category-edit-2"
set submit_label "Save Changes"
set title "Edit a Category"

# bboard_category_get -category_id $category_id -column_array category
# bboard_forum_get -forum_id $category(forum_id) -column_array forum

# set forum_name $forum(short_name)
# set forum_id $forum(forum_id)
# set short_name $category(short_name)

db_1row category_info {
    select f.short_name as forum_name, f.forum_id, c.short_name
      from bboard_forums f, bboard_categories c
      where c.category_id = :category_id
        and f.forum_id = c.forum_id
}

set context_bar \
	[list [list "forum?[export_url_vars forum_id]" $forum_name] \
	      "Edit a Category"]

ad_return_template category-entry
