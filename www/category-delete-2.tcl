ad_page_contract {

    Delete a category

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-12-01
    @cvs-id $Id$

} {
    category_id:integer,notnull,bboard_category_id
}

ad_require_permission $category_id bboard_delete_category

db_1row forum_id {
    select forum_id from bboard_categories where category_id = :category_id
}

db_exec_plsql delete_category {
    begin
        bboard_category.delete (:category_id);
    end;
}

ad_returnredirect "forum?forum_id=$forum_id"