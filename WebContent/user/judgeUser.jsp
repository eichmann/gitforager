<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:update dataSource="jdbc/GitHubTagLib">
    update github.search_user set relevant = ?::boolean where sid = ?::int and uid = ?::int
    <sql:param>${param.relevant}</sql:param>
	<sql:param>${param.sid}</sql:param>
	<sql:param>${param.uid}</sql:param>
</sql:update>

<sql:query var="rels" dataSource="jdbc/GitHubTagLib">
    select count(*) as count from github.search_user where relevant is null and sid = ?::int
    <sql:param>${param.sid}</sql:param>
</sql:query>
<c:forEach items="${rels.rows}" var="row">
	<c:set var="count" value="${row.count}" />
</c:forEach>

<c:choose>
	<c:when test="${count == 0}">
		<c:redirect url="../search/search_list.jsp" />
	</c:when>
	<c:otherwise>
		<c:redirect url="user.jsp">
			<c:param name="sid" value="${param.sid}" />
		</c:redirect>
	</c:otherwise>
</c:choose>
