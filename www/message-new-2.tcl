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
    
    Confirmation page for a new posting.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-datee 2000-08-29
    @cvs $Id$

    @param forum_id    The forum to post to
    @param title       The message title
    @param content     The message contents
    @param category_id The category to post to
    @param reply_to    The message this is in reply to
} {
    forum_id:integer,notnull,bboard_forum_id
    title:notnull,trim
    content:notnull,allhtml,trim
    mime_type:notnull
    category_id:integer,bboard_category_id
    {reply_to:integer,acs_message_id ""}
} -validate {
    content_html -requires {content mime_type} {
	if [string eq $mime_type "text/html"] {
	    set complaint [ad_html_security_check $content]
	    if ![empty_string_p $complaint] {
		ad_complain $complaint
	    }
	}
    }
} -properties { 
    page_title:onevalue
    context_bar:onevalue
    forum_name:onevalue
    content_for_display:onevalue
    title:onevalue
    message_id:onevalue
    form_vars:onevalue
    reply_to:onevalue
    target:onevalue
    subscribe_p:onevalue
    msg_mime_type:onevalue
}

ns_log Notice "mime_type is $mime_type"
set subscribe_p 1

set user_id [ad_verify_and_get_user_id]

ad_require_permission $forum_id bboard_create_message

set target "message-new-3"

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set page_title "Confirm Message for Posting in $forum_name"

set context_bar [list \
	[list "forum?[export_url_vars forum_id]" $forum_name] \
	"Post"]

set content_for_display [acs_messaging_format_as_html $mime_type $content]

set message_id [db_nextval acs_object_id_seq]

set msg_mime_type $mime_type

set form_vars [export_form_vars message_id forum_id title content \
	                        mime_type category_id reply_to]

if ![string equal $reply_to ""] {
    set subscribe_p 0
} else {
    if {[string equal [bboard_category_subscribed_p $user_id $category_id] "t"] ||
        [string equal [bboard_forum_subscribed_p $user_id $forum_id] "t"]} {
	set subscribe_p 0
    } else {
	set subscribe_p 1
    }
}

ad_return_template "message-preview"
