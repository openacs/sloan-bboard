ad_page_contract {

    Edit a category

    @author John Prevost <jprevost@arsdigita.com>
    @creation-date 2000-09-07
    @cvs-id $Id$

    @param category_id The ID of the category to update
    @param short_name  The short name of the forum
    @param forum_id    The forum ID the category is in (to redirect back to)

} {
    category_id:integer,notnull,bboard_category_id
    short_name:notnull,trim
    forum_id:integer,notnull,bboard_forum_id
}

ad_require_permission $category_id bboard_write_category

db_transaction {
    bboard_category_set -category_id $category_id -short_name $short_name
}
# on error ...

ad_returnredirect "forum?[export_url_vars forum_id]"
