<master src="master">
<property name="context_bar">@context_bar@</property>
<property name="title">Delete a Category</property>

You are going to delete the category "@category_name@", causing all
@message_count@ messages in it to be placed in the category "Unknown".

<center>
<p>Are you sure you want to delete this category?<p>

<a href="category-delete-2?category_id=@category_id@">Yes</a> &nbsp; &nbsp;
<a href="<%= [get_referrer_and_query_string] %>">No</a>
</center>
