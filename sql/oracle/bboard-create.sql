--
-- packages/bboard/sql/bboard-create.sql
--
-- @author Anukul Kapoor <akk@arsdigita.com>
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2000-08-29
-- @cvs-id $Id$
--

set feedback off

-- separate parts so that if one fails, the rest happens

begin

    -- create the privileges

    acs_privilege.create_privilege('bboard_create_forum');
    acs_privilege.create_privilege('bboard_create_category');
    acs_privilege.create_privilege('bboard_create_message');
    acs_privilege.create_privilege('bboard_write_forum');
    acs_privilege.create_privilege('bboard_write_category');
    acs_privilege.create_privilege('bboard_write_message');
    acs_privilege.create_privilege('bboard_read_forum');
    acs_privilege.create_privilege('bboard_read_category');
    acs_privilege.create_privilege('bboard_read_message');
    acs_privilege.create_privilege('bboard_delete_forum');
    acs_privilege.create_privilege('bboard_delete_category');
    acs_privilege.create_privilege('bboard_delete_message');
    acs_privilege.create_privilege('bboard_moderate_forum');

end;
/
show errors

begin

    -- bind privileges to global names

    acs_privilege.add_child('create','bboard_create_forum');
    acs_privilege.add_child('create','bboard_create_category');
    acs_privilege.add_child('create','bboard_create_message');
    acs_privilege.add_child('write','bboard_write_forum');
    acs_privilege.add_child('write','bboard_write_category');
    acs_privilege.add_child('write','bboard_write_message');
    acs_privilege.add_child('read','bboard_read_forum');
    acs_privilege.add_child('read','bboard_read_category');
    acs_privilege.add_child('read','bboard_read_message');
    acs_privilege.add_child('delete','bboard_delete_forum');
    acs_privilege.add_child('delete','bboard_delete_category');
    acs_privilege.add_child('delete','bboard_delete_message');
    acs_privilege.add_child('admin','bboard_moderate_forum');
end;
/
show errors


declare
    default_context acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public acs_objects.object_id%TYPE;
begin

    default_context := acs.magic_object_id('default_context');
    registered_users := acs.magic_object_id('registered_users');
    the_public := acs.magic_object_id('the_public');

    -- give registered users the power to post by default

    acs_permission.grant_permission (
        object_id => default_context,
        grantee_id => registered_users,
        privilege => 'bboard_create_message'
    );

    -- give the public the power to read by default

    acs_permission.grant_permission (
        object_id => default_context,
        grantee_id => the_public,
        privilege => 'bboard_read_message'
    );

    acs_permission.grant_permission (
        object_id => default_context,
        grantee_id => the_public,
        privilege => 'bboard_read_category'
    );

    acs_permission.grant_permission (
        object_id => default_context,
        grantee_id => the_public,
        privilege => 'bboard_read_forum'
    );

    acs_object_type.create_type (
        supertype => 'acs_object',
        object_type => 'bboard_forum',
        pretty_name => 'BBoard Forum',
        pretty_plural => 'BBoard Forum',
        table_name => 'BBOARD_FORUMS',
        id_column => 'FORUM_ID',
        name_method => 'BBOARD_FORUM.NAME'
    );

    acs_object_type.create_type (
        supertype => 'acs_object',
        object_type => 'bboard_category',
        pretty_name => 'BBoard Category',
        pretty_plural => 'BBoard Categories',
        table_name => 'BBOARD_CATEGORIES',
        id_column => 'CATEGORY_ID',
        name_method => 'BBOARD_CATEGORY.NAME'
    );

end;
/
show errors


-- bboard forums
--
-- these act as primary containers for messages
-- a message's context_id will point to its forum

create table bboard_forums (
    forum_id integer
        constraint bboard_forums_forum_id_fk
            references acs_objects (object_id)
        constraint bboard_forums_pk
            primary key,    
    short_name varchar(400)
        constraint bboard_forums_short_name_nn
            not null,
    charter varchar(4000),
    moderated_p char(1)
        constraint bboard_forums_moderated_p_nn
            not null
        constraint bboard_forums_moderated_p_ck
            check (moderated_p in ('t','f')),
    forum_type  varchar(200) default 'q-and-a' 
        constraint bboard_forums_forum_type_nn not null
        constraint bboard_forums_forum_type_ck
                   check (forum_type in ('q-and-a','thread')),
    track_new_postings_p   char(1) default 'f'
        constraint bboard_forums_track_new_ck
                   check (track_new_postings_p in ('t','f')),
    bboard_id integer
        constraint bboard_forums_bboard_id_nn
            not null
        constraint bboard_forums_bboard_id_fk
            references apm_packages (package_id)
                on delete cascade
);

create index bboard_forums_bboard_id_idx
    on bboard_forums (bboard_id);

create table bboard_forum_message_map (
    forum_id integer
        constraint bboard_fmm_forum_id_fk
            references bboard_forums (forum_id)
                on delete cascade,
    message_id integer
        constraint bboard_fmm_message_id_fk
            references acs_messages (message_id)
                on delete cascade,
    status varchar(20)
        constraint bboard_fmm_status_ck
            check (status in ('unmoderated', 'approved', 'rejected'))
        constraint bboard_fmm_status_nn
            not null,
    constraint bboard_forum_message_map_pk
        primary key (forum_id, message_id)
);

create index bboard_fmm_message_id_idx
    on bboard_forum_message_map (message_id);

create index bboard_fmm_status_idx
    on bboard_forum_message_map (status);

--
-- For tracking individual views on messages
-- (This is a client request, but I still think this will be problematic - ben)
--
create table bboard_message_user_map (
       message_id integer
          constraint bboard_mum_message_id_fk
            references acs_messages (message_id)
            on delete cascade,
       user_id integer
          constraint bboard_mum_user_id_fk
            references users (user_id)
            on delete cascade,
       view_date date default sysdate
          constraint bboard_mum_view_date_nn
          not null
);

-- bboard categories
--
-- these are for intra-forum categorization
-- categories will be scoped to forums via their acs_object.context_id

create table bboard_categories (
    category_id integer
        constraint bboard_c_category_id_fk
            references acs_objects (object_id)
        constraint bboard_c_category_id_pk
            primary key,
    short_name varchar(400)
        constraint bboard_c_short_name_nn
            not null,
    forum_id integer
        constraint bboard_c_forum_id_fk
            references bboard_forums (forum_id)
                on delete cascade
        constraint bboard_c_forum_id_nn
            not null,
    description varchar(4000)
);

create index bboard_categories_forum_id_idx
    on bboard_categories (forum_id);

create table bboard_category_message_map (
    category_id integer
        constraint bboard_cmm_category_id_fk
            references bboard_categories (category_id)
                on delete cascade,
    message_id integer
        constraint bboard_cmm_message_id_fk
            references acs_messages (message_id)
                on delete cascade,
    constraint bboard_category_message_map_pk
        primary key (category_id, message_id)
);

create index bboard_cmm_message_id_idx
    on bboard_category_message_map (message_id);

@@ bboard-views

-- Tables to track subscriptions

create table bboard_forum_subscribers (
    forum_id integer
        constraint bboard_fs_forum_id_fk
            references bboard_forums (forum_id)
                on delete cascade,
    subscriber_id integer
        constraint bboard_fs_subscriber_id_fk
            references parties (party_id)
                on delete cascade,
    constraint bboard_forum_subscribers_pk
        primary key (forum_id, subscriber_id)
);

create index bboard_fs_subscriber_id_idx
    on bboard_forum_subscribers (subscriber_id);

create table bboard_category_subscribers (
    category_id integer
        constraint bboard_cs_category_id_fk
            references bboard_categories (category_id)
                on delete cascade,
    subscriber_id integer
        constraint bboard_cs_subscriber_id_fk
            references parties (party_id)
                on delete cascade,
    constraint bboard_category_subscribers_pk
        primary key (category_id, subscriber_id)
);

create index bboard_cs_subscriber_id_idx
    on bboard_category_subscribers (subscriber_id);

create table bboard_thread_subscribers (
    thread_id integer
        constraint bboard_ts_thread_id_fk
            references acs_messages (message_id)
                on delete cascade,
    subscriber_id integer
        constraint bboard_ts_subscriber_id_fk
            references parties (party_id)
                on delete cascade,
    constraint bboard_thread_subscribers_pk
        primary key (thread_id, subscriber_id)
);

create index bboard_ts_subscriber_id_idx
    on bboard_thread_subscribers (subscriber_id);

@@ bboard-packages

insert into cr_mime_types (mime_type) 
    values ('text/plain; format=flowed');

set feedback on

-- This was stolen from ACS 3.x www/doc/sql/site-wide-search.sql
-- to provide functionality until it is refactored into the ACS core

-- Query to take free text user entered query and frob it into something
-- that will make interMedia happy. Provided by Oracle.

create or replace function bboard_im_convert(
	query in varchar2 default null
	) return varchar2
is
  i   number :=0;
  len number :=0;
  char varchar2(1);
  minusString varchar2(256);
  plusString varchar2(256); 
  mainString varchar2(256);
  mainAboutString varchar2(500);
  finalString varchar2(500);
  hasMain number :=0;
  hasPlus number :=0;
  hasMinus number :=0;
  token varchar2(256);
  tokenStart number :=1;
  tokenFinish number :=0;
  inPhrase number :=0;
  inPlus number :=0;
  inWord number :=0;
  inMinus number :=0;
  completePhrase number :=0;
  completeWord number :=0;
  code number :=0;  
begin
  
  len := length(query);

-- we iterate over the string to find special web operators
  for i in 1..len loop
    char := substr(query,i,1);
    if(char = '"') then
      if(inPhrase = 0) then
        inPhrase := 1;
	tokenStart := i;
      else
        inPhrase := 0;
        completePhrase := 1;
	tokenFinish := i-1;
      end if;
    elsif(char = ' ') then
      if(inPhrase = 0) then
        completeWord := 1;
        tokenFinish := i-1;
      end if;
    elsif(char = '+') then
      inPlus := 1;
      tokenStart := i+1;
    elsif((char = '-') and (i = tokenStart)) then
      inMinus :=1;
      tokenStart := i+1;
    end if;

    if(completeWord=1) then
      token := '{ '||substr(query,tokenStart,tokenFinish-tokenStart+1)||' }';      
      if(inPlus=1) then
        plusString := plusString||','||token||'*10';
	hasPlus :=1;	
      elsif(inMinus=1) then
        minusString := minusString||'OR '||token||' ';
	hasMinus :=1;
      else
        mainString := mainString||' NEAR '||token;
	mainAboutString := mainAboutString||' '||token; 
	hasMain :=1;
      end if;
      tokenStart  :=i+1;
      tokenFinish :=0;
      inPlus := 0;
      inMinus :=0;
    end if;
    completePhrase := 0;
    completeWord :=0;
  end loop;

  -- find the last token
  token := '{ '||substr(query,tokenStart,len-tokenStart+1)||' }';
  if(inPlus=1) then
    plusString := plusString||','||token||'*10';
    hasPlus :=1;	
  elsif(inMinus=1) then
    minusString := minusString||'OR '||token||' ';
    hasMinus :=1;
  else
    mainString := mainString||' NEAR '||token;
    mainAboutString := mainAboutString||' '||token; 
    hasMain :=1;
  end if;

  
  mainString := substr(mainString,6,length(mainString)-5);
  mainAboutString := replace(mainAboutString,'{',' ');
  mainAboutString := replace(mainAboutString,'}',' ');
  mainAboutString := replace(mainAboutString,')',' ');	
  mainAboutString := replace(mainAboutString,'(',' ');
  plusString := substr(plusString,2,length(plusString)-1);
  minusString := substr(minusString,4,length(minusString)-4);

  -- we find the components present and then process them based on the specific combinations
  code := hasMain*4+hasPlus*2+hasMinus;
  if(code = 7) then
    finalString := '('||plusString||','||mainString||'*2.0,about('||mainAboutString||')*0.5) NOT ('||minusString||')';
  elsif (code = 6) then  
    finalString := plusString||','||mainString||'*2.0'||',about('||mainAboutString||')*0.5';
  elsif (code = 5) then  
    finalString := '('||mainString||',about('||mainAboutString||')) NOT ('||minusString||')';
  elsif (code = 4) then  
    finalString := mainString;
    finalString := replace(finalString,'*1,',NULL); 
    finalString := '('||finalString||')*2.0,about('||mainAboutString||')';
  elsif (code = 3) then  
    finalString := '('||plusString||') NOT ('||minusString||')';
  elsif (code = 2) then  
    finalString := plusString;
  elsif (code = 1) then  
    -- not is a binary operator for intermedia text
    finalString := 'totallyImpossibleString'||' NOT ('||minusString||')';
  elsif (code = 0) then  
    finalString := '';
  end if;

  return finalString;
end;
/

-- NOTE: this is only temporary until we figure out how
--       packages will register child types to an acs-message
declare
    v_exists	integer;
begin

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'content_revision'
      );
    end if;

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'image'
      );
    end if;

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'content_extlink'
      );
    end if;

end;
/
show errors
