<if @messages:rowcount@ eq 0>
  <i>There are no messages available.</i><p>
</if>

<else>
 <table width="90%" cellpadding="3" cellspacing="0" border="0">
  <tr bgcolor="#ECECEC">
   <if @score_p@ not nil and @score_p@ eq 1>
    <th align="left" width="10%">Score</th>
   </if>
   <th align="left">Subject</th> 
   <if @author_p@ nil or @author_p@ ne 0>
    <th align="left">Author</th>  
   </if>
   <if @reply_count_p@ nil or @reply_count_p@ ne 0>
    <th align="left">Replies</th>
   </if>
    <if @last_updated_p@ not nil and @last_updated_p@ ne 0>
     <th align="left">Last update</th>
    </if>	
    <if @sent_date_p@ not nil and @sent_date_p@ ne 0>
     <th align="left">Date</th>
    </if>	
  </tr>
  <multiple name=messages>
   <tr>
    <if @score_p@ not nil and @score_p@ eq 1>
     <td>@messages.the_score@</td>
    </if>
    <if @top_p@ not nil and @top_p@ ne 0>
     <td><a href="<%=[bboard_message_url -top @messages.message_id@ @forum_id@]%>">@messages.title@</a></td>
    </if> 
    <else>
     <td><a href="<%=[bboard_message_url @messages.message_id@ @forum_id@]%>">@messages.title@</a></td>
    </else>
   <if @author_p@ nil or @author_p@ ne 0>
     <td>@messages.full_name@</td> 
    </if> 
    <if @reply_count_p@ nil or @reply_count_p@ ne 0>
     <td><%= [expr @messages.num_replies@-1] %></td>
    </if> 
    <if @last_updated_p@ not nil and @last_updated_p@ ne 0>
     <td>@messages.last_updated@</td>
    </if>	
    <if @sent_date_p@ not nil and @sent_date_p@ ne 0>
     <td>@messages.sent_date@</td>
    </if>	
   </tr>
  </multiple>
 </table>
</else>
