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

    We will do the grunt work here of creating an attachment.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-date 2000-12-18
    @cvs $Id$

} {
    message_id:integer,notnull
    file_id:integer,notnull
    file_title:notnull
    upload_file:notnull
    upload_file.tmpfile:tmpfile
} 

ad_require_permission $message_id bboard_write_message

# authenticate the user
set user_id [ad_conn user_id]

# aolserver will give us a guessed mime type for the upload
set guessed_file_type [ns_guesstype $upload_file]

# let us get the useful bits out of the long filename
set full_filename ${upload_file.tmpfile}
set base_filename [bboard_upload_basename $upload_file]
set file_ext [bboard_upload_extension $full_filename]

# check file size against user parameters

set n_bytes [file size $full_filename]
set max_file_size [ad_parameter MaxAttachmentSize]

if { $n_bytes > $max_file_size && $max_file_size > 0 } {
    ad_return_complaint 1 "Your file is too large.  The publisher of
                 [ad_system_name] has chosen to limit attachments to
                 [util_commify_number $max_file_size] bytes.\n"
}
if { $n_bytes == 0 } {
    ad_return_complaint 1 "Your file is zero-length.  Either you attempted to
                 upload a zero length file, a file which does not exists, 
                 or something went wrong during the transfer.\n"
}


# insert the file into the database

db_transaction {

    # check for and add MIME types missing from cr mime types table
    bboard_check_and_register_mime_type $guessed_file_type

    if { $file_ext == "jpeg" || $file_ext == "jpg" || $file_ext == "gif" } {
	set image_size [bboard_image_size $file_ext $upload_file]
	set width [lindex $image_size 0]
	set height [lindex $image_size 1]
	
	bboard_attach_image -message_id $message_id -file_id $file_id \
		-short_filename $base_filename -local_filename $full_filename\
		-mime_type $guessed_file_type -user_id $user_id \
		-creation_ip [ad_conn peeraddr] -title $file_title \
		-width $width -height $height
    } else {
	bboard_attach_file -message_id $message_id -file_id $file_id \
		-short_filename $base_filename -local_filename $full_filename\
		-mime_type $guessed_file_type -user_id $user_id \
		-creation_ip [ad_conn peeraddr] -title $file_title
    }
}

ad_returnredirect [bboard_message_url $message_id]
