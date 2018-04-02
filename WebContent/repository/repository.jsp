<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="git" uri="http://icts.uiowa.edu/GitHubTagLib"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>gitForager 1.0 - Repository</title>
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
    <div id="content"><jsp:include page="/header.jsp" flush="true" />
        <jsp:include page="/menu.jsp" flush="true"><jsp:param
                name="caller" value="research" /></jsp:include><div id="centerCol">
 
            <c:choose>
            <c:when test="${not empty param.sid}">
                 <sql:query var="rels" dataSource="jdbc/GitHubTagLib">
                     select rid, rank from github.search_repository where relevant is null and sid=?::int and exists (select id from github.repository where id=rid) order by rank limit 1;
                 <sql:param>${param.sid}</sql:param>
                 </sql:query>
                 <c:forEach items="${rels.rows}" var="row">
                     <c:set var="rid" value="${row.rid}"/>
                     <c:set var="rank" value="${row.rank}"/>
                 </c:forEach>
            </c:when>
            <c:otherwise>
                 <c:set var="rid" value="${param.id}" />
            </c:otherwise>
            </c:choose>

            <git:repository ID="${rid}">
            <h2><a href="http://github.com/<git:repositoryFullName/>"><git:repositoryFullName/></a></h2>
            
            <c:if test="${not empty param.sid}">
                <h3>Rank: ${rank} - <a href="judgeRepository.jsp?relevant=true&sid=${param.sid}&rid=${rid}">relevant</a> - <a href="judgeRepository.jsp?relevant=false&sid=${param.sid}&rid=${rid}">non-relevant</a></h3>
            </c:if>

            <p><b>Name:</b> <git:repositoryName/></p>
            <git:foreachUserRepo var="x">
                <git:userRepo>
                    <c:set var="uid" value="${git:userRepoUserIdValue()}"/>
                    <git:user ID="${uid}">
                        <c:choose>
                        <c:when test="${empty git:userNameValue() }">
	                        <p><b>Owner:</b> <a href="<util:applicationRoot/>/user/user.jsp?id=<git:userID/>"><git:userLogin/></a></p>
                        </c:when>
                        <c:otherwise>
	                        <p><b>Owner:</b> <a href="<util:applicationRoot/>/user/user.jsp?id=<git:userID/>"><git:userName/></a></p>
                        </c:otherwise>
                        </c:choose>
                    </git:user>
                </git:userRepo>
            </git:foreachUserRepo>
            <git:foreachOrgRepo var="x">
                <git:orgRepo>
                    <c:set var="orgid" value="${git:orgRepoOrganizationIdValue()}"/>
                    <git:organization ID="${orgid}">
                        <c:choose>
                        <c:when test="${empty git:organizationNameValue() }">
	                        <p><b>Owner:</b> <a href="<util:applicationRoot/>/organization/organization.jsp?id=<git:organizationID/>"><git:organizationLogin/></a></p>
                        </c:when>
                        <c:otherwise>
	                        <p><b>Owner:</b> <a href="<util:applicationRoot/>/organization/organization.jsp?id=<git:organizationID/>"><git:organizationName/></a></p>
                        </c:otherwise>
                        </c:choose>
                    </git:organization>
                </git:orgRepo>
            </git:foreachOrgRepo>
            <p><b>Description:</b> <git:repositoryDescription/></p>
            <c:if test="${git:repositoryForkValue()}">
                <git:foreachParent var="x">
                    <git:parent>
                        <p><b>Forked from:</b> <a href="<util:applicationRoot/>/repository/repository.jsp?id=<git:parentParentId/>"><git:parentParentFullName/></a></p>
                    </git:parent>
                </git:foreachParent>
            </c:if>
            <p><b>Created:</b> <git:repositoryCreatedAt/></p>
            <p><b>Updated:</b> <git:repositoryUpdatedAt/></p>
            <p><b>Pushed:</b> <git:repositoryPushedAt/></p>
            <p><b>Homepage:</b>
            <c:choose>
            <c:when test="${fn:startsWith(git:repositoryHomepageValue(),'http')}">
             <a href="<git:repositoryHomepage/>"><git:repositoryHomepage/></a>
            </c:when>
            <c:otherwise>
             <a href="http://<git:repositoryHomepage/>"><git:repositoryHomepage/></a>
            </c:otherwise>
            </c:choose>
            </p>
            <p><b>Size:</b> <git:repositorySize/></p>
            <p><b>Language:</b> <git:repositoryLanguage/></p>
            
            <c:if test="${git:readmeExists(rid)}">
            <h3>README</h3>
            <git:foreachReadme var="x">
                <git:readme>
                    <util:markdown2html><git:readmeReadme/></util:markdown2html>
                </git:readme>
            </git:foreachReadme>
            </c:if>

            </git:repository>

            <jsp:include page="/footer.jsp" flush="true" /></div>
    </div>
</body>
</html>

