#
#  Copyright (C) 2001, 2002 OpenForce, Inc.
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    
    Confirmation page for editing a message.

    @author John Prevost <jmp@arsdigita.com>
    @creation-datee 2000-09-08
    @cvs $Id$

    @param message_id  The message to update
    @param title       The new title
    @param content     The new content
    @param mime_type   The new mime type
    @param category_id The new category
} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
    title:notnull,trim
    content:notnull,allhtml,trim
    mime_type:notnull
    category_id:integer,bboard_category_id
} -validate {
    content_html -requires {content mime_type} {
        if [string eq $mime_type "text/html"] {
            set complaint [ad_check_for_naughty_html $content]
            if ![empty_string_p $complaint] {
                ad_complain $complaint
		return 0
            }
        }
	return 1
    }
} -properties { 
    forum_id:onevalue
    page_title:onevalue
    context_bar:onevalue
    forum_name:onevalue
    content_for_display:onevalue
    title:onevalue
    message_id:onevalue
    form_vars:onevalue
    reply_to:onevalue
    target:onevalue
    msg_mime_type:onevalue
}

ad_require_permission $message_id bboard_write_message

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set target "message-edit-3"

set msg_mime_type $mime_type

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set page_title "Confirm Message Changes in $forum_name"

set context_bar [list \
        [list "forum?[export_url_vars forum_id]" $forum_name] \
        "Confirm Message Edit"]

set content_for_display [acs_messaging_format_as_html $mime_type $content]


set form_vars [export_form_vars message_id forum_id title content \
                                mime_type category_id reply_to]

ad_return_template "message-preview"
