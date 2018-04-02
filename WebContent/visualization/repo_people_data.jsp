<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="graph" uri="http://slis.uiowa.edu/graphtaglib"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<c:set var="singleQuote">'</c:set>
<c:set var="doubleQuote">"</c:set>
<graph:graph>
	
	<sql:query var="repo" dataSource="jdbc/GitHubTagLib">
		select id, name, full_name, description, homepage 
		from github.repository, github.search_repository
		where github.repository.id = github.search_repository.rid
		and github.search_repository.sid = ?::int
		and relevant
		<sql:param>${param.id}</sql:param>
	</sql:query>
	<c:forEach items="${repo.rows}" var="row" varStatus="rowCounter">
		<graph:node uri="r${row.id}" label="${row.name}" group="1" />
	</c:forEach>

	<sql:query var="people" dataSource="jdbc/GitHubTagLib">
		select github.user.id as id, coalesce(github.user.name, github.user.login, 'No Name') as name, github.user.company as comp
		from github.user
		where github.user.id in 
      			(select github.user_repo.user_id
      			from github.user_repo 
      			where github.user_repo.repository_id in 
      					(select github.search_repository.rid 
						from github.search_repository 
						where github.search_repository.sid = ?::int and relevant)
	  	);
        <sql:param>${param.id}</sql:param>
	</sql:query>
	<c:forEach items="${people.rows}" var="row" varStatus="rowCounter">
		<graph:node uri="${row.id}" label="${row.name}"  group="2" />
	</c:forEach>

	<sql:query var="commiters" dataSource="jdbc/GitHubTagLib">
		select distinct coalesce(cast(github.commit.user_id as text), github.commit.name) as id, coalesce(github.commit.name,github.commit.login) as name
		from github.commit
		where id in 
			(select github.repository.id  
			from github.repository, github.search_repository
			where github.repository.id = github.search_repository.rid
			and github.search_repository.sid = ?::int and relevant);
        <sql:param>${param.id}</sql:param>
	</sql:query>
	<c:forEach items="${commiters.rows}" var="row" varStatus="rowCounter">
		<graph:node uri="${row.id}" label="${row.name}"  group="3" />
	</c:forEach>
	
	<sql:query var="links_commit" dataSource="jdbc/GitHubTagLib">
		select github.commit.id as id, coalesce(cast(github.commit.user_id as text), github.commit.name) as login, count(*) as number
		from github.commit
		where id in 
			(select github.repository.id  
			from github.repository, github.search_repository
			where github.repository.id = github.search_repository.rid
			and github.search_repository.sid = ?::int and relevant)
		group by commit.id, commit.user_id, commit.name;
        <sql:param>${param.id}</sql:param>
	</sql:query>
	<c:forEach items="${links_commit.rows}" var="row" varStatus="rowCounter">
		<graph:edge source="r${row.id}" target="${row.login}"  weight="${row.number}" />
	</c:forEach>
	
	<sql:query var="links" dataSource="jdbc/GitHubTagLib">
		select distinct github.repository.id as id, github.user.id as login
		from github.repository, github.user, github.user_repo
		where github.repository.id in 
				(select github.search_repository.rid 
				from github.search_repository 
				where github.search_repository.sid = ?::int and relevant)
		and github.repository.id = github.user_repo.repository_id
		and github.user_repo.user_id = github.user.id;
        <sql:param>${param.id}</sql:param>
	</sql:query>
	<c:forEach items="${links.rows}" var="row" varStatus="rowCounter">
		<graph:edge source="r${row.id}" target="${row.login}"  weight=".5" />
	</c:forEach>
	
	

{
  "nodes":[
		<graph:foreachNode >
			<graph:node>
		    	{"url":"<util:regexRewrite source='\\\\' target='\\\\\\\\'><graph:nodeUri/></util:regexRewrite>","name":"<util:regexRewrite source='"' target='\\"'><util:regexRewrite source='\\\\' target='\\\\\\\\'><graph:nodeLabel/></util:regexRewrite></util:regexRewrite>","group":<graph:nodeGroup/>}<c:if test="${ ! isLastNode }">,</c:if>
			</graph:node>
		</graph:foreachNode>
  ],
  
  "links":[
  	<graph:foreachEdge>
  		<graph:edge>
		    {"source":<graph:edgeSource/>,"target":<graph:edgeTarget/>,"weight":<graph:edgeWeight/>}<c:if test="${ ! isLastEdge }">,</c:if>
  		</graph:edge>
  	</graph:foreachEdge>
  ]
}
</graph:graph>
