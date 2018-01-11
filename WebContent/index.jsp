<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PubMed Central Acknowledgements 1.0</title>
<style type="text/css" media="all">    @import "<util:applicationRoot/>/resources/style.css";</style></head>
<body>
<div id="content"><jsp:include page="/header.jsp" flush="true" /> <jsp:include page="/menu.jsp" flush="true"><jsp:param name="caller" value="research" /></jsp:include><div id="centerCol">
Initial deployment of an app supporting exploration of PubMed Central acknowledgements.
<h2>Sites Currently Crawled</h2>
                <sql:query var="terms" dataSource="jdbc/GitHubTagLib">
                    select id,term
                    from github.search_term
                    order by id
                </sql:query>
                <table>
                <tr><th>ID</th><th>Term</th></tr>
                <c:forEach items="${terms.rows}" var="row" varStatus="rowCounter">
                <tr><td>${row.id}</td><td>${row.term}</td></tr>
                </c:forEach>
                </table>

<jsp:include page="/footer.jsp" flush="true" /></div></div></body>
</html>

