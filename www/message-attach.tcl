ad_page_contract {

    This page presents a form for creating a message attachment.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-datee 2000-12-18
    @cvs $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
    message_id:integer,notnull
} -properties {
    title:onevalue
    context_bar:onevalue
    file_id:onevalue
    message_id:onevalue
    forum_id:onevalue
}

ad_require_permission $message_id bboard_write_message

set title "Upload message attachment"
set context_bar ""

set file_id [db_nextval acs_object_id_seq]

ad_return_template