ad_page_contract {

    Create a new forum.

    @author John Prevost <jprevost@arsdigita.com>
    @creation-date 2000-08-30
    @cvs-id $Id$

    @param forum_id    The ID of the new forum to be created (debounce)
    @param short_name  The short name of the forum
    @param charter     The long description (charter) of the forum
    @param moderated_p Should the forum be moderated?
} {
    forum_id:integer,notnull
    short_name:notnull,trim
    charter:trim
    {moderated_p:optional ""}
}

ad_require_permission [ad_conn package_id] admin

if [empty_string_p $moderated_p] {
    set moderated_p "f"
} else {
    set moderated_p "t"
}

set package_id [ad_conn package_id]

db_transaction {
    bboard_forum_new -forum_id $forum_id -short_name $short_name \
	    -charter $charter -moderated_p $moderated_p \
	    -bboard_id $package_id -creation_user [ad_verify_and_get_user_id] \
	    -creation_ip [ad_conn peeraddr] -context_id $package_id
}
# on error ...

ad_returnredirect "."
