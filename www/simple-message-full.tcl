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
    Display a single message in a reasonable way.

    @author John Prevost <jmp@arsdigita.com>
    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2000-11-30
    @cvs-id $Id$
} {
} -properties {
    mail_friend_p:onevalue
    attachments_p:onevalue
    attachments:multirow
    formatted_content:onevalue
}

set mail_friend_p [ad_parameter "MailFriendEnabledP"]
set attachments_p [ad_parameter "AttachmentsEnabledP"]

if {![info exists new_p]} {
    set new_p "f"
}

if {[ad_parameter "UserPostsDeletableP"] == "t"} {
    if [info exists write_p] {
	set delete_p $write_p
    }
} else {
    if [info exists admin_p] {
	set delete_p $admin_p
    }
}
 
set formatted_content [acs_messaging_format_as_html $mime_type $content] 

# we don't want to stomp on the 
set current_user_id [ad_conn user_id]

if {[string equal $attachments_p "t"] && [info exists id]} {
    db_multirow attachments get_attachments {
	select object_id as file_id, cr.title, ci.name
            from acs_objects ao, cr_items ci, cr_revisions cr
            where object_id = ci.item_id and
                  live_revision = revision_id and
	          object_type = 'content_item' and
                  context_id = :id
    }
}
