ad_page_contract {

    Displays a list of forums on the site

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-08-29
    @cvs-id $Id$
} {
} -properties {
  context_bar:onevalue
  package_id:onevalue
  user_id:onevalue
  forums:multirow
}

set package_id [ad_conn package_id]

set context_bar {}

set user_id [ad_verify_and_get_user_id]

set admin_p [ad_permission_p $package_id admin]

db_multirow forums forums_select {
    select forum_id, short_name, moderated_p, charter 
      from bboard_forums f
      where bboard_id = :package_id
        and acs_permission.permission_p(forum_id,:user_id,'bboard_read_forum') = 't'
    order by short_name
}

set bboard_forum_name [bboard_forum_name]
set bboard_forum_name_plural [bboard_forum_name_plural]

ad_return_template
