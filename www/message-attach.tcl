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
