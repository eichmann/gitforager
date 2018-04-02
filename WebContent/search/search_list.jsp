<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="git" uri="http://icts.uiowa.edu/GitHubTagLib"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>gitForager 1.0 - Current Searches</title>
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
	<div id="content"><jsp:include page="/header.jsp" flush="true" />
		<jsp:include page="/menu.jsp" flush="true"><jsp:param
				name="caller" value="research" /></jsp:include><div id="centerCol">
			<h2>Current Searches</h2>
            <table>
                <tr>
                    <th rowspan=2>ID</th>
                    <th rowspan=2>Term</th>
                    <th rowspan=2># Repos</th>
                    <th rowspan=2># Users</th>
                    <th rowspan=2># Orgs</th>
                    <th colspan=3># Unjudged</th>
                </tr>
                <tr>
                    <th>Users</th>
                    <th>Orgs</th>
                    <th>Repos</th>
                </tr>
			<git:foreachSearchTerm var="x" sortCriteria="term">
			 <git:searchTerm>
                    <tr>
                        <td><git:searchTermID/></td>
                        <td><a href="search.jsp?id=<git:searchTermID/>"><git:searchTermTerm/></a></td>
                        <td>${git:searchRepositoryCountBySearchTerm(git:searchTermIDValue()) }</td>
                        <td>${git:searchUserCountBySearchTerm(git:searchTermIDValue()) }</td>
                        <td>${git:searchOrganizationCountBySearchTerm(git:searchTermIDValue()) }</td>
                        <td>
                            <sql:query var="rels" dataSource="jdbc/GitHubTagLib">
                                select count(*) as count from github.search_user where relevant is null and sid = ?::int
                                <sql:param>${git:searchTermIDValue()}</sql:param>
                            </sql:query>
                            <c:forEach items="${rels.rows}" var="row">
                                <c:if test="${row.count > 0}">
                                    <a href="<util:applicationRoot/>/user/user.jsp?sid=${git:searchTermIDValue()}">${row.count}</a>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <sql:query var="rels" dataSource="jdbc/GitHubTagLib">
                                select count(*) as count from github.search_organization where relevant is null and sid = ?::int
                                <sql:param>${git:searchTermIDValue()}</sql:param>
                            </sql:query>
                            <c:forEach items="${rels.rows}" var="row">
                                <c:if test="${row.count > 0}">
                                    <a href="<util:applicationRoot/>/organization/organization.jsp?sid=${git:searchTermIDValue()}">${row.count}</a>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <sql:query var="rels" dataSource="jdbc/GitHubTagLib">
                                select count(*) as count from github.search_repository where relevant is null and sid = ?::int
                                <sql:param>${git:searchTermIDValue()}</sql:param>
                            </sql:query>
                            <c:forEach items="${rels.rows}" var="row">
                                <c:if test="${row.count > 0}">
                                    <a href="<util:applicationRoot/>/repository/repository.jsp?sid=${git:searchTermIDValue()}">${row.count}</a>
                                </c:if>
                            </c:forEach>
                        </td>
                    </tr>
			 </git:searchTerm>
			</git:foreachSearchTerm>
			</table>

            <form action="addSearch.jsp">
            Add a search:
            <input name="term" size=50>
            <input type=submit name=submitButton value=add>
            </form>
			<jsp:include page="/footer.jsp" flush="true" /></div>
	</div>
</body>
</html>

