ad_page_contract {
    Delete an attachment.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-date 2000-12-30
    @cvs $Id$
} {
    file_id:integer,notnull
    message_id:integer,notnull
}

ad_require_permission $file_id bboard_write_message

bboard_delete_attachment $file_id

ad_returnredirect [bboard_message_url $message_id]