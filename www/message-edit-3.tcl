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
    
    Update edited message

    @author John Prevost <jmp@arsdigita.com>
    @creation-datee 2000-09-08
    @cvs $Id$

    @param message_id   The message to update
    @param category_id  The new category
    @param title        The new title
    @param content      The new content
    @param mime_type    The new mime type

} {
    forum_id:integer,notnull,bboard_forum_id
    message_id:integer,notnull,acs_message_id
    category_id:integer,bboard_category_id
    title:notnull,trim
    content:allhtml,notnull,trim
    mime_type:notnull
} -validate {
    content_html -requires {content mime_type} {
	if [string eq $mime_type "text/html"] {
	    set complaint [ad_html_security_check $content]
	    if ![empty_string_p $complaint] {
		ad_complain $complaint
	    }
	}
    }
} 

ad_require_permission $message_id bboard_write_message

db_transaction {

    bboard_message_clear_categories -message_id $message_id
    
    if ![empty_string_p $category_id] {
        bboard_message_add_category -message_id $message_id \
                -category_id $category_id
    }

    bboard_message_set -message_id $message_id -title $title \
            -mime_type $mime_type -content $content

}
# on error ...

ad_returnredirect "forum?[export_url_vars forum_id]"
