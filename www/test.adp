<%

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

%>

<master src="master">
<property name="context_bar"></property>
<property name="title">test</property>

<pre><%=[ns_quotehtml "{}{}{}<><><><foo>bar</bar>"]%></pre>

<pre><%=[ad_conn location] [ad_conn package_url] %></pre>
<pre><%= [bboard_message_url 8035 1592]%></pre>
<pre><%= [bboard_message_url -absolute 8035 1592]%></pre>
<pre><%= %></pre>
<pre><%= %></pre>
<pre><%= %></pre>


<% bboard_garbage_collect %>
