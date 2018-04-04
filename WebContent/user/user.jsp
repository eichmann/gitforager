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
<title>gitForager 1.0 - User</title>
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
                     select uid, rank from github.search_user where relevant is null and sid=?::int order by rank limit 1;
                 <sql:param>${param.sid}</sql:param>
                 </sql:query>
                 <c:forEach items="${rels.rows}" var="row">
                     <c:set var="uid" value="${row.uid}"/>
                     <c:set var="rank" value="${row.rank}"/>
                 </c:forEach>
            </c:when>
            <c:otherwise>
                 <c:set var="uid" value="${param.id}" />
            </c:otherwise>
            </c:choose>

			<git:user ID="${uid}">
				<h2>
					<git:userName />
				</h2>

                <c:if test="${not empty param.sid}">
                    <h3>Rank: ${rank} - <a href="judgeUser.jsp?relevant=true&sid=${param.sid}&uid=${uid}">relevant</a> - <a href="judgeUser.jsp?relevant=false&sid=${param.sid}&uid=${uid}">non-relevant</a></h3>
                </c:if>

				<p>
					<b>Login:</b>
					<git:userLogin />
				</p>
				<p>
					<b>Company:</b>
					<git:userCompany />
				</p>
				<p>
					<b>Location:</b>
					<git:userLocation />
				</p>
				<p>
					<b>email:</b>
					<git:userEmail />
				</p>
				<p>
					<b>Bio:</b>
					<git:userBio />
				</p>
            <p><b>Blog:</b>
            <c:choose>
            <c:when test="${fn:startsWith(git:userBlogValue(),'http')}">
             <a href="<git:userBlog/>"><git:userBlog/></a>
            </c:when>
            <c:otherwise>
             <a href="http://<git:userBlog/>"><git:userBlog/></a>
            </c:otherwise>
            </c:choose>
            </p>
				<p>
					<b>Blog:</b>
					<git:userBlog />
				</p>

                <c:if test="${git:userHasMember(uid)}">
                    <h3>Member of </h3>
                    <ol class="bulletedList">
                        <git:foreachMember var="x" useOrganization="true" sortCriteria="name">
                            <git:member>
                                <c:set var="oid" value="${git:memberOrganizationIdValue()}" />
                                <git:organization ID="${oid}">
                                    <li><a href="<util:applicationRoot/>/organization/organization.jsp?id=<git:organizationID/>"><git:organizationName /></a>
                                </git:organization>
                            </git:member>
                        </git:foreachMember>
                    </ol>
                </c:if>

			<h3>Repositories</h3>
			<dl>
				<git:foreachUserRepo var="x" useRepository="true" sortCriteria="name">
					<git:userRepo>
						<c:set var="rid" value="${git:userRepoRepositoryIdValue()}" />
						<git:repository ID="${rid}">
							<dt>
								<a
									href="<util:applicationRoot/>/repository/repository.jsp?id=<git:repositoryID/>"><git:repositoryName /></a>
							</dt>
							<dd>
								<git:repositoryDescription />
							</dd>
						</git:repository>
					</git:userRepo>
				</git:foreachUserRepo>
			</dl>

            <p><b>Commits To</b>
            <table>
            <tr><th>Repository</th><th>Most Recent Commit</th><th># Commits</th></tr>
            <git:foreachCommitter var="x">
            	<git:committer>
                    <c:set var="rid" value="${git:committerRidValue()}"/>
                    <git:repository ID="${rid}">
                        <tr><td><a href="<util:applicationRoot/>/repository/repository.jsp?id=<git:repositoryID/>"><git:repositoryFullName/></a></td><td><git:committerMostRecent/></td><td><git:committerCount/></td></tr>
            		</git:repository>
            	</git:committer>
            </git:foreachCommitter>
            </table>
            <p>
            
            </git:user>

			<jsp:include page="/footer.jsp" flush="true" /></div>
	</div>
</body>
</html>

