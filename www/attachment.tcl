ad_page_contract {
    This serves an attachment file.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2000-12-30
    @cvs-id $Id$
} {
    file_id:integer,notnull
}

if [string equal [ad_parameter "AttachmentsEnabledP"] "t"] {
    ad_require_permission $file_id bboard_read_forum
    cr_write_content -item_id $file_id
} else {
    ad_return_complaint 1 "Attachments are currently disabled"
}
