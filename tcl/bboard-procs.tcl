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

ad_library {

    Provides functions for creating and updating bboard messages, forums,
    and categories.  Also provides functions for constructing queries
    for bboard messages.

    @creation-date 2000-10-21
    @author John Prevost <jmp@arsdigita.com>
    @cvs-id $Id$

}

ad_proc -public bboard_forum_p {
    {forum_id}
} {
    Check if an integer is a valid bboard forum id.
} {
    return [string equal [db_exec_plsql bboard_forum_p {
        begin
            :1 := bboard_forum.forum_p(:forum_id);
        end;
    }] "t"]
}

ad_page_contract_filter bboard_forum_id { name value } {
    Checks whether the value (assumed to be an integer) is the id of
    an already-existing bboard forum.
} {
    # empty is okay (handled by notnull)
    if [empty_string_p $value] {
	return 1
    }
    if ![bboard_forum_p $value] {
	ad_complain "$name ($value) does not refer to a valid bboard forum"
	return 0
    }
    return 1
}

ad_proc -public bboard_forum_new {
    {-forum_id ""}
    {-short_name:required}
    {-forum_type "q-and-a"}
    {-charter ""}
    {-moderated_p f}
    {-bboard_id:required}
    {-context_id ""}
    {-creation_user ""}
    {-creation_ip ""}
} {
    Create a new forum.
} {
    return [db_exec_plsql create_forum {
        begin
            :1 := bboard_forum.new (
                forum_id => :forum_id,
                short_name => :short_name,
                charter => :charter,
                moderated_p => :moderated_p,
                forum_type => :forum_type,
                bboard_id => :bboard_id,
                context_id => :context_id,
                creation_user => :creation_user,
                creation_ip => :creation_ip
            );
        end;
    }]
}

ad_proc -public bboard_forum_set {
    {-forum_id:required}
    {-short_name ""}
    {-charter ""}
    {-moderated_p ""}
    {-bboard_id ""}
} {
    Modify some or all of a forum's attributes.
} {
    db_exec_plsql update_forum {
        begin
            bboard_forum.set_attrs (
                forum_id => :forum_id,
                short_name => :short_name,
                charter => :charter,
                moderated_p => :moderated_p,
                bboard_id => :bboard_id
            );
        end;
    }
}

ad_proc -public bboard_forum_get {
    {-forum_id:required}
    {-column_array:required}
 } {
    Get the columns for a given forum into an array variable.
} {
    upvar $rowvar row
    db_1row forum_get {
        select * from bboard_forums where forum_id = :forum_id
    } -column_array row
}

ad_proc -public bboard_category_p {
    {category_id}
} {
    Check if an integer is a valid bboard category id.
} {
    return [string equal [db_exec_plsql bboard_category_p {
        begin
            :1 := bboard_category.category_p(:category_id);
        end;
    }] "t"]
}

ad_page_contract_filter bboard_category_id { name value } {
    Checks whether the value (assumed to be an integer) is the id of
    an already-existing bboard category.
} {
    # empty is okay (handled by notnull)
    if [empty_string_p $value] {
	return 1
    }
    if ![bboard_category_p $value] {
	ad_complain "$name ($value) does not refer to a valid bboard category"
	return 0
    }
    return 1
}

ad_proc -public bboard_category_new {
    {-category_id ""}
    {-short_name:required}
    {-description ""}
    {-forum_id:required}
} {
    Create a new category.
} {
    return [db_exec_plsql create_category {
	begin
	    :1 := bboard_category.new (
	        category_id => :category_id,
	        short_name => :short_name,
	        description => :description,
	        forum_id => :forum_id
	    );
	end;
    }]
}

ad_proc -public bboard_category_set {
    {-category_id:required}
    {-short_name ""}
    {-description ""}
    {-forum_id ""}
} {
    Modify some or all of a category's attributes.
} {
    db_exec_plsql update_category {
        begin
            bboard_category.set_attrs (
                category_id => :category_id,
                short_name => :short_name,
                description => :description,
                forum_id => :forum_id
            );
        end;
    }
}

ad_proc -public bboard_category_get {
    {-category_id:required}
    {-column_array:required}
} {
    Get the columns for a given category into an array variable.
} {
    upvar $rowvar row
    db_1row category_get {
        select * from bboard_categories where category_id = :category_id
    } -column_array row
}

ad_proc -public bboard_message_new {
    {-message_id ""}
    {-reply_to ""}
    {-sent_date ""}
    {-sender ""}
    {-title ""}
    {-mime_type ""}
    {-content ""}
    {-context_id ""}
    {-creation_user ""}
    {-creation_ip ""}
} {
    Create a new message.
} {
    set result [db_exec_plsql message_new {
        begin
            :1 := bboard_message.new (
                message_id => :message_id,
                reply_to => :reply_to,
                sent_date => :sent_date,
                sender => :sender,
                title => :title,
                mime_type => :mime_type,
                data => empty_blob(),
                context_id => :context_id,
                creation_user => :creation_user,
                creation_ip => :creation_ip
            );
        end;
    }]


    if [string equal $message_id ""] {
	set message_id $result
    }

    db_1row message_new_revision {
        select live_revision as revision_id
            from cr_items
            where item_id = :message_id
        for update
    }

    db_dml message_new_set_blob {
        update cr_revisions
            set content = empty_blob()
            where revision_id = :revision_id
        returning content into :1
    } -blobs [list $content]

    return $result
}

ad_proc -public bboard_message_set {
    {-message_id:required}
    {-reply_to ""}
    {-sent_date ""}
    {-sender ""}
    {-title ""}
    {-mime_type ""}
    {-context_id ""}
    {-content ""}
} {
    Modify one or more attributes of a given message.
} {
    db_exec_plsql message_set_attr {
        begin
            bboard_message.set_attrs (
                message_id => :message_id,
                reply_to => :reply_to,
                sent_date => :sent_date,
                sender => :sender,
                title => :title,
                mime_type => :mime_type,
                context_id => :context_id
            );
        end;
    }
    db_1row message_revision {
        select live_revision as revision_id from cr_items
            where item_id = :message_id
            for update
    }
    db_dml message_set_content {
        update cr_revisions
            set content = empty_blob()
            where revision_id = :revision_id
        returning content into :1
    } -blobs [list $content]
}

ad_proc -public bboard_message_clear_categories {
    {-message_id:required}
} {
    Clear all category associations from one message.
} {
    db_exec_plsql bboard_message_clear_categories {
        begin
            bboard_message.clear_categories ( :message_id );
        end;
    }
}

ad_proc -public bboard_message_add_category {
    {-message_id:required}
    {-category_id:required}
} {
    Add one category relationship to a message.
} {
    db_exec_plsql bboard_message_add_category {
        begin
            bboard_message.add_category (
                message_id => :message_id,
                category_id => :category_id
            );
        end;
    }
}

ad_proc -public bboard_message_remove_category {
    {-message_id:required}
    {-category_id:required}
} {
    Remove one category relationship from a message.
} {
    db_exec_plsql bboard_message_remove_category {
        begin
            bboard_message.remove_category (
                message_id => :message_id,
                category_id => :category_id
            );
        end;
    }
}

ad_proc -public bboard_message_set_status {
    {-message_id:required}
    {-forum_id:required}
    {-status:required}
} {
    Modify the status of a message in a particular forum.  Null status is
    not in the forum.  Acceptable statuses are unmoderated, approved, and
    rejected.
} {
    db_exec_plsql bboard_message_set_status {
        begin
            bboard_message.set_status (
                message_id => :message_id,
                forum_id => :forum_id,
                status => :status
            );
        end;
    }
}

ad_proc -public bboard_message_get {
    {-message_id:required}
    {-column_array:required}
} {
    Get the columns for a given message into an array variable.
} {
    upvar $rowvar row
    db_1row message_get {
        select * from acs_messages_all where message_id = :message_id
    } -column_array row
}

ad_proc -public bboard_schedule_sends {
    {-message_id:required}
    {-email_message_id}
} {
    Schedule all message sends for the given message.
    
    Supports sending an email version of the message given the
    optional email_message_id.  In this case the message stored with
    $email_message_id is sent out to whoever is subscribed to
    $message_id.  
} {

    # If we don't have a specific message that is to be sent, just use
    # the original.

    if ![info exists email_message_id] {
	set email_message_id $message_id
    }

    # Thread based sends
    acs_messaging_send_query -message_id $email_message_id \
	    -query [db_map thread_subscribers] \
            -bind [list message_id $message_id]

    # Category based sends
    acs_messaging_send_query -message_id $email_message_id \
	    -query [db_map category_subscribers] \
	    -bind [list message_id $message_id]

    # Forum based sends
    acs_messaging_send_query -message_id $email_message_id \
	    -query [db_map forum_subscribers] \
	    -bind [list message_id $message_id]
}

ad_proc -public bboard_subscribe_forum {
    {-forum_id:required}
    {-subscriber_id:required}
} {
    Subscribe a user to the given forum (for instant updates, right now.)
} {
    db_exec_plsql forum_subscribe {
        begin
            bboard_forum.subscribe (
                forum_id => :forum_id,
                subscriber_id => :subscriber_id
            );
        end;
    }
}

ad_proc -public bboard_unsubscribe_forum {
    {-forum_id:required}
    {-subscriber_id:required}
} {
    Unsubscribe a user from the given forum.
} {
    db_dml forum_unsubscribe {
        delete from bboard_forum_subscribers
            where forum_id = :forum_id
                and subscriber_id = :subscriber_id
    }
}

ad_proc -public bboard_subscribe_category {
    {-category_id:required}
    {-subscriber_id:required}
} {
    Subscribe a user to the given category (for instant updates, right now.)
} {
    db_exec_plsql category_subscribe {
        begin
            bboard_category.subscribe (
                category_id => :category_id,
                subscriber_id => :subscriber_id
            );
        end;
    }
}

ad_proc -public bboard_unsubscribe_category {
    {-category_id:required}
    {-subscriber_id:required}
} {
    Unsubscribe a user from the given category.
} {
    db_dml category_unsubscribe {
        delete from bboard_category_subscribers
            where category_id = :category_id
                and subscriber_id = :subscriber_id
    }
}

ad_proc -public bboard_subscribe_thread {
    {-thread_id:required}
    {-subscriber_id:required}
} {
    Subscribe a user to the given thread (for instant updates, right now.)
} {
    db_exec_plsql thread_subscribe {
        begin
            bboard_message.subscribe (
                thread_id => :thread_id,
                subscriber_id => :subscriber_id
            );
        end;
    }
}

ad_proc -public bboard_unsubscribe_thread {
    {-thread_id:required}
    {-subscriber_id:required}
} {
    Unsubscribe a user from the given thread.
} {
    db_dml thread_unsubscribe {
        delete from bboard_thread_subscribers
            where thread_id = :thread_id
                and subscriber_id = :subscriber_id
    }
}

ad_proc -public bboard_category_subscribed_p {
    {-direct:boolean}
    user_id
    category_id
} {
    Returns "t" or "f" based on whether a user is subscribed to a 
    particular category.  The -direct switch checks only category
    subscriptions whereas leaving it off checks for the category,
    and any forums the category is in.
} {
    db_0or1row check_category_subscribed {
        select count(*) as subscribed_p from bboard_category_subscribers
            where category_id = :category_id
                and subscriber_id = :user_id
    }

    if {$subscribed_p > 0} {
	return "t"
    } else {
	if {!$direct_p} {
	    # if direct isn't defined, we should also check
	    # for 

	    db_0or1row check_category_forums_subscribed {
		select count(*) as subscribed_p from bboard_forum_subscribers
     	            where subscriber_id = :user_id
		        and forum_id in (select bc.forum_id
		                            from bboard_categories bc
  		                            where bc.category_id = 
                                                  :category_id)
	    }

	    if {$subscribed_p > 0} {
		return "t"
	    }
	}
    }

    return "f"
}

ad_proc -public bboard_forum_subscribed_p {
    user_id
    forum_id
} {
    Returns "t" or "f" based on whether a user is subscribed to a 
    particular forum, category, or thread.
} {
    db_0or1row check_forum_subscribed {
        select count(*) as subscribed_p 
            from bboard_forum_subscribers
            where forum_id = :forum_id
                and subscriber_id = :user_id
    }

    if {$subscribed_p > 0} {
	return "t"
    } else {
	return "f"
    }
}

ad_proc -public bboard_message_subscribed_p {
    {-direct:boolean}
    user_id
    message_id
} {
    Returns "t" or "f" based on whether a user is subscribed to a 
    particular thread.
} {
    db_1row check_message_subscribed {
	select count(*) as subscribed_p from bboard_thread_subscribers
	where subscriber_id = :user_id
	      and thread_id in (select message_id
	                        from acs_messages b
	                        connect by b.message_id = prior b.reply_to 
	                        start with message_id = :message_id)

    }

    if {$subscribed_p > 0} {
	return "t"
    } else {
	if {! $direct_p } {
	    db_1row check_message_cats_subscribed {
		select count(*) as subscribed_p 
		from bboard_category_subscribers
		where subscriber_id = :user_id
		      and category_id in (select bcmm.category_id
		                          from bboard_category_message_map bcmm
		                          where bcmm.message_id = :message_id)

	    }

	    if {$subscribed_p > 0} {
		return "t"
	    } else {
		db_0or1row check_message_forums_subscribed {
		    select count(*) as subscribed_p 
		    from bboard_forum_subscribers
		    where subscriber_id = :user_id
		          and forum_id in (select bfmm.forum_id
   		                           from bboard_forum_message_map bfmm
		                           where bfmm.message_id = :message_id)
		}

		if {$subscribed_p > 0} {
		    return "t"
		}
	    }
	}
    }
    return "f"
}

ad_proc -public bboard_message_forum {
    {message_id}
} {
    Returns a forum_id for a forum that the supplied message is in.  Returns 0
    if the message id isn't found.
} {
    db_1row bboard_forum_containing_message {
	select bboard_forum.forum_containing_message(:message_id) as forum_id
	  from dual
    }

    return $forum_id
}

ad_proc -public bboard_forum_moderated_p {
    {forum_id}
} {
    Returns "t" if the forum is moderated, "f" otherwise
} {
    db_1row forum_moderated_p {
	select moderated_p
  	  from bboard_forums
	  where forum_id = :forum_id
    }

    return $moderated_p
}

ad_proc bboard_message_page {
} {
    Returns the appropriate page name to display a message.  This
    proc consults preferences to determine different display styles.
} {
    if {[string compare [ad_parameter "ThreadingEnabledP"] "t"] == 0} {
	return "message-threaded"
    } else {
	return "message"
    }
}

ad_proc -public bboard_message_url {
    {-absolute:boolean}
    {-top:boolean}
    {message_id}
    {forum_id ""}
} {
    Returns the proper URL for displaying the message with the supplied message_id.

    If given the -absolute flag it will return a full url.

    When the absolute flag is specified, this proc must be called from
    within a live page since it depends on ad_conn being around.

} {
    # This is a workaround to a bug in acs-messaging-procs/first_ancestor
    # that won't be deployed until after this next bboard release -akk

    if {! $top_p} {
        db_1row first_ancestor {
	    select acs_message.first_ancestor(:message_id) as ancestor_id 
                from dual
        }
    } else {
        set ancestor_id $message_id
    }

    if { $message_id == $ancestor_id } {
	set anchor ""
    } else {
	set anchor "#$message_id"
    }

    # if we don't have a forum_id, let's pick one!

    # use of this violates the assumption
    # that messages can be in multiple forums

    if [string equal $forum_id ""] {
	set forum_id [bboard_message_forum $ancestor_id]
    }

    set message_id $ancestor_id
    if {$absolute_p} {
	set prefix "[ad_conn location][ad_conn package_url]"
    } else {
	set prefix ""
    }

    return "$prefix[bboard_message_page]?message_id=$message_id&forum_id=$forum_id$anchor"
}

ad_proc -public bboard_subscriptions_url {} {
    Returns URL for managing bboard subscriptions.
} {
    return "[ad_conn location][ad_conn package_url]subscriptions"
}

# if i were cool, i'd implement an Omega(log n) solution for this
# i am not however, cool

ad_proc -public bboard_n_spaces {
    {n}
} {
    Returns a string containg n HTML spaces i.e &amp;nbsp;
} {
    set spaces ""
    for {set i 0} {$i < $n} {incr i} {
	append spaces "&nbsp;"
    }
    return $spaces
}


ad_proc -public bboard_upload_extension {
    {filename}
} {
    This proc returns the stripped file extensions of a filename.
} {
    # get the file extension
    set file_extension [string tolower [file extension $filename]]

    # remove the first . from the file extension
    regsub {\.} $file_extension "" file_extension
    
    return $file_extension
}

ad_proc -public bboard_upload_basename {
    {filename}
} {
    This proc attempts to return the base of a passed in filename i.e.
    it strips off the C:\directories and associated crud.
    e.g. C:\bar\baz\qux.flad -> qux.flad
} {
    # strip off the C:\directories... crud and just get the file name
    if ![regexp {([^/\\]+)$} $filename match filename] {
	# couldn't find a match
	set filename $filename
    }

    return $filename
}

ad_proc -public bboard_image_size {
    {file_extension}
    {filename}
} {
    This proc returns a list [width height] from an image if it can determine
    this information from the file and file extension.
} {

    set what_aolserver_told_us ""

    if { $file_extension == "jpeg" || $file_extension == "jpg" } {
	catch { set what_aolserver_told_us [ns_jpegsize $filename] }
    } elseif { $file_extension == "gif" } {
	catch { set what_aolserver_told_us [ns_gifsize $filename] }
    }
    
    # the AOLserver jpegsize command has some bugs where the height comes 
    # through as 1 or 2 
    if { ![empty_string_p $what_aolserver_told_us] && 
          [lindex $what_aolserver_told_us 0] > 10 && 
          [lindex $what_aolserver_told_us 1] > 10 } {
	return $what_aolserver_told_us
    } else {
	return [list "" ""]
    }
}

ad_proc -public bboard_check_and_register_mime_type {
    {type}
} {
    This proc checks for or registers a mime_type in the content
    repository type registry.
} {
    # we don't do this as a transaction.
    # or god forbid hold an exclusive lock

    # since if someone else adds this type at the same
    # moment, we don't care.

    db_0or1row check_mime_type {
	select mime_type
	    from cr_mime_types
	    where mime_type = :type
    }

    if ![info exists mime_type] {
	    db_dml insert_mime {
		insert into cr_mime_types (mime_type)
		values (:type)
	    }
    }
}

ad_proc -public bboard_attach_image {
    {-message_id:required}
    {-file_id ""}
    {-short_filename:required}
    {-local_filename:required}
    {-mime_type:required}
    {-width ""}
    {-height ""}
    {-title ""}
    {-user_id ""}
    {-creation_ip ""}
} {
    Creates a message image attachment.
} {
        db_exec_plsql insert_image {
             begin
                :1 := acs_message.new_image (
                    message_id     => :message_id,
                    image_id       => :file_id,
                    file_name      => :short_filename,
                    title          => :title,
                    mime_type      => :mime_type,
                    content        => empty_blob(),
                    width          => :width,
                    height         => :height,
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => 't'
            );
            end;
        }

    db_1row get_revision {
        select content_item.get_latest_revision(:file_id) as revision_id
        from dual
    }

    set filename [cr_create_content_file $file_id $revision_id $local_filename]
    set size [file size $local_filename]

    db_dml set_content_size ""
}

ad_proc -public bboard_attach_file {
    {-message_id:required}
    {-file_id ""}
    {-short_filename:required}
    {-local_filename:required}
    {-mime_type:required}
    {-title ""}
    {-user_id ""}
    {-creation_ip ""}
} {
    Creates a new bboard attachment.
} {
        db_exec_plsql insert_file {
            begin
                :1 := acs_message.new_file (
                    message_id     => :message_id,
                    file_id        => :file_id,
                    file_name      => :short_filename,
                    title          => :title,
                    mime_type      => :mime_type,
                    content        => empty_blob(),
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => 't'
            );
            end;
        }

    db_1row get_revision {
        select content_item.get_latest_revision(:file_id) as revision_id
        from dual
    }
    
    set filename [cr_create_content_file $file_id $revision_id $local_filename]
    set size [file size $local_filename]

    db_dml set_content_size ""
}


ad_proc -public bboard_delete_attachment {
    {file_id}
} {
    Deletes an attachment.
} {
    if [db_0or1row is_file_image {
	select image_id
            from images
            where image_id = content_item.get_latest_revision(:file_id)
    }] {
	db_exec_plsql delete_image {
	    begin
	        acs_message.delete_image(:file_id);
	    end;
	}
    } else {
	db_exec_plsql delete_file {
	    begin
   	        acs_message.delete_file(:file_id);
	    end;
	}
    }
}

# A new proc to figure out how a user wishes to see things
ad_proc -public bboard_user_view_pref {
    {-user_id ""}
} {
    Check what viewing preference a user has.
    Implemented for dotLRN.
    
    @author ben@openforce.biz
} {
    if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }

    # FIXME: fix this when we have real user preference tracking
    return "full"
}

ad_proc -public bboard_forum_name {
} {
    return "Bboard"
}

ad_proc -public bboard_forum_name_plural {
} {
    return "Bboards"
}

ad_proc -public bboard_alert_from_address {
} {
    Returns an appropriate from address for bboard alerts.
} {
    return "bboard-robot@[ad_conn host]"
}

ad_proc -public bboard_alert_message {
    {-mime_type:required}
    {-content:required}
    {-message_id:required}
    {-forum_id:required}
    {-sender:required}
} {
    Takes a bboard message and returns a text message
} {
    db_1row forum_info {
	select short_name as forum_name
	    from bboard_forums
	    where forum_id = :forum_id
    }

    if {[string equal $mime_type "text/plain"]} {
	set result $content
    } elseif {[string equal $mime_type "text/plain; format=flowed"]} {
	set result [wrap_string $content]
    } elseif {[string equal $mime_type "text/html"]} {
	set result [ad_html_to_text $content]
    } else {
	set result "Error display bboard posting as email!
Our bboard system has received a post we don't know how to 
send via email.  Please go to the below URL for a better shot 
at displaying."
    }
    
    set header "Posted by:  $sender"

    set footer "--------------------
This is a posting from the $forum_name bboard.
To reply you can go to:
[bboard_message_url -absolute $message_id $forum_id]
To unsubscribe from this or other bboard posts go to:
[bboard_subscriptions_url]"

    return "${header}

${result}

${footer}"
}

ad_proc -public bboard_alert_one_mesg {
    {-message_id:required}
    {-forum_id:required}
    {-user_id:required}
    {-creation_ip ""}
} {
    This proc does generates the appropriate alerts for a new bboard post.

    This proc must be called from within a live page since it depends on
    ad_conn being around.
} {
    db_1row bboard_mesg_info {
	select reply_to, sender, title, mime_type, content, email,
               first_names||' '||last_name as full_name
            from acs_messages_all, persons, parties
            where message_id = :message_id
                  and person_id = sender
	          and party_id = person_id
    }

    db_1row forum_info {
	select short_name as forum_name
	    from bboard_forums
	    where forum_id = :forum_id
    }

    set email_mesg_id [bboard_message_new -sender $user_id \
                         -title "$title \[$forum_name\]" \
                         -mime_type "text/plain" \
                         -content [bboard_alert_message -mime_type $mime_type \
                                       -content $content \
                                       -sender "$full_name <$email>" \
                                       -message_id $message_id \
                                       -forum_id $forum_id] \
                         -context_id $message_id -creation_user $user_id \
                         -creation_ip $creation_ip]

    bboard_schedule_sends -message_id $message_id \
                          -email_message_id $email_mesg_id
}

ad_proc -private bboard_garbage_collect {
} {
    garbage collects deleted messages, message email artifacts, etc.,

    In particular, this deletes message objects that aren't currently
    in a forum, but that are children of bboard messages or bboard forums.

    DRB: The bboard package duplicates messages when you choose to mail one
    to a friend, setting the new message's context_id to the original message.
    This new message doesn't belong to a forum.  The context_id is used to
    retrieve these via CONNECT BY and they're then deleted (presumably under
    the assumption that they've been e-mailed immediately).

    This is context_id abuse.  Context_id is supposed to be used for 
    permissions inheritance only.  This is one of several instances in the
    toolkit where context_id is used to link objects together in a hierarchy
    in a way that has nothing to do with permissions.  It sucks and must be
    fixed later (along with a bunch of other crap in this relatively ugly
    package).

    I don't think orphans arise in other circumstances but I could be wrong
    as I've not scoured the code thoroughly yet.

} {
    acs_messaging_process_queue

    if {[db_type] == "postgresql"} {
	bboard_garbage_collect_postgresql
    } else {
	db_exec_plsql bboard_alert_clean ""
    }
}


ad_proc -private bboard_garbage_collect_postgresql {} {
    Works around postgresql bugs that make it impossible
    to delete multiple items in a single transaction

    DRB fixed the assumption that only general-comments and bboard use acs_messaging

} {
    db_foreach get_orphans {
          select object_id as message_id
          from acs_objects o
          where o.object_type = 'acs_message'
            and not exists (select 1
                            from bboard_forum_message_map bfmm, acs_objects o2
                            where o2.object_id = bfmm.message_id and
                            o.tree_sortkey between o2.tree_sortkey and tree_right(o2.tree_sortkey))
    } {
        db_dml clear_revision_references {
            update cr_items
               set latest_revision=null, live_revision=null
             where item_id = :message_id
        }

        db_exec_plsql delete_message {
            select bboard_message__remove(:message_id);
        }
    }
}
