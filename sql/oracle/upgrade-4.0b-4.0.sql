--
-- packages/bboard/sql/upgrade-4.0b-4.0.sql
--
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2000-11-22
-- @cvs-id $Id$
--

create table bboard_category_subscribers (
    category_id integer
        constraint bboard_cs_category_id_fk
            references bboard_categories (category_id),                   
    subscriber_id integer                                  
        constraint bboard_cs_subscriber_id_fk
            references parties (party_id),
    constraint bboard_category_subscribers_pk
        primary key (category_id, subscriber_id)
);

@@ bboard-packages

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
