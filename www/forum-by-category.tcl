ad_page_contract {

    Displays a list of messages in a forum

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-08-29
    @cvs-id $Id$
} {
    category_id:integer,bboard_category_id
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    forum_write_p:onevalue
    forum_create_p:onevalue
    context_bar:onevalue
    title:onevalue
    forum_name:onevalue
    forum_id:onevalue
    category_id:onevalue
    messages:multirow
    categories:multirow
    moderator_p:onevalue
    unapproved:multirow
    rejected:multirow
    subscribed_p:onevalue
}

ad_require_permission $forum_id bboard_read_forum

set moderator_p 0

set category_create_p 0

set user_id [ad_verify_and_get_user_id]

set subscribed_p 0

set admin_p [ad_permission_p $forum_id admin]

db_1row forum_info {
    select f.short_name as forum_name, f.moderated_p
        from bboard_forums f
        where f.forum_id = :forum_id
}


if ![string eq $category_id ""] {
    db_1row forum_info {
        select f.forum_id, f.short_name as forum_name, f.moderated_p
            from bboard_categories c, bboard_forums f
            where c.category_id = :category_id
                and c.forum_id = f.forum_id
    }

    if [string equal $moderated_p "t"] {
	set moderator_p [ad_permission_p $forum_id bboard_moderate_forum]
    }

    db_1row category_info {
        select short_name as category_name from bboard_categories
          where category_id = :category_id
    }

} else {
    set category_name "Uncategorized"
}


if { ![string eq $category_id ""] && [string equal [bboard_category_subscribed_p -direct $user_id $category_id] "t"]} {
    set subscribed_p 1
} else {
    set subscribed_p 0
}

set context_bar [list [list "forum?[export_url_vars forum_id]" $forum_name] \
		      $category_name]
set title "$forum_name: $category_name"

set package_id [ad_conn package_id]

db_multirow categories categories_select_none {
    select 1 from dual where 0 = 1
}

if [string equal $moderated_p "f"] {
    set moderated_sql ""
} else {
    set moderated_sql "and status = 'approved'"
}

if {[string eq $category_id ""]} {
    set category_sql "and category_id is null"
} else {
    set category_sql "and category_id = :category_id"
}


db_multirow messages messages_select_by_cat "
    select message_id, title, num_replies,
         first_names||' '||last_name as full_name,
  	 to_char(last_reply_date,'MM/DD/YY hh12:Mi am') as last_updated
    from bboard_messages_by_category b, persons
    where person_id = sender
        and reply_to is null
        and forum_id = :forum_id
  	$category_sql
        $moderated_sql
    order by sent_date desc
	"

if { !$moderator_p } {

    db_multirow unapproved unapproved_none {
	select 1 from dual where 1 = 0
    }

    db_multirow rejected rejected_none {
	select 1 from dual where 1 = 0
    }

} else {

    db_multirow unapproved messages_select_unmoderated {
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_by_category, persons
	  where category_id = :category_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'unmoderated'
    }

    db_multirow rejected rejected_messages_select {
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_by_category, persons
	  where category_id = :category_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'rejected'
    }

}

ad_return_template "forum-view"
