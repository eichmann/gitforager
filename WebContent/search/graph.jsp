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
	<div id="content">
	   <jsp:include page="/header.jsp" flush="true" />
<jsp:include page="/menu.jsp" flush="true"><jsp:param name="caller" value="research" /></jsp:include>
<div id="centerCol">
            <git:searchTerm ID="${param.id}">
            <h2>Search: <git:searchTermTerm/></h2>
            </git:searchTerm>
		<jsp:include page="../visualization/forceGraph.jsp" flush="true">
		  <jsp:param name="id" value="${param.id}" /></jsp:include><div id="centerCol">
		<jsp:include page="/footer.jsp" flush="true" /></div>
	</div></div>
</body>
</html>

