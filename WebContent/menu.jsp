<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<div id=leftCol>
<br>
<h3><a href="<util:applicationRoot/>/index.jsp">Home</a></h3>
<h3><a href="<util:applicationRoot/>/search/search_list.jsp">Searches</a></h3>
<h3>Entities</h3>
<ul>
<li><a href="<util:applicationRoot/>/organization/organization_list.jsp">Organizations</a>
<ol class="bulletedList">
    <li><a href="<util:applicationRoot/>/organization/organization_search.jsp">search</a>
    <li><a href="<util:applicationRoot/>/organization/organization_by_frequency.jsp">by frequency</a>
</ol></li>
<li><a href="<util:applicationRoot/>/person/person_list.jsp">Persons</a>
<ol class="bulletedList">
    <li><a href="<util:applicationRoot/>/person/person_search.jsp">search</a>
    <li><a href="<util:applicationRoot/>/person/person_by_frequency.jsp">by frequency</a>
</ol></li>
</ul>
<h3>Analytics</h3>
<ul>
    <li><a href="<util:applicationRoot/>/analytics/domain_graph.jsp">domain graph</a>
</li>
</ul>
<h3><a href="<util:applicationRoot/>/template/index.jsp">Templates</a></h3>
<ul>
<li><a href="<util:applicationRoot/>/template/browse_pattern.jsp">Browse by tgrep pattern</a>
<li><a href="<util:applicationRoot/>/template/browse_unbound.jsp">Browse unbound fragments</a>
<li><a href="<util:applicationRoot/>/template/browse.jsp">Browse all fragments</a>
</ul>
</div>
