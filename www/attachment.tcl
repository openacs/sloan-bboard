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
