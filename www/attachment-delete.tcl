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
