<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="git" uri="http://icts.uiowa.edu/GitHubTagLib"%>


<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="../head.jsp" flush="true">
    <jsp:param name="title" value="CD2H gitForager" />
</jsp:include>
<style type="text/css" media="all">
@import "../resources/layout.css";
</style>

<body class="home page-template-default page page-id-6 CD2H">
    <jsp:include page="../header.jsp" flush="true" />

    <div class="container pl-0 pr-0">
        <br /> <br />
        <div class="container-fluid">

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
            </div>
            <div style="width: 100%; float: left">
                <jsp:include page="../footer.jsp" flush="true" />
            </div>
        </div>
    </div>
</body>

</html>


