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
			         select orgid, rank from github.search_organization where relevant is null and sid=?::int order by rank limit 1;
			     <sql:param>${param.sid}</sql:param>
			     </sql:query>
			     <c:forEach items="${rels.rows}" var="row">
			         <c:set var="orgid" value="${row.orgid}"/>
                     <c:set var="rank" value="${row.rank}"/>
			     </c:forEach>
			</c:when>
			<c:otherwise>
			     <c:set var="orgid" value="${param.id}" />
			</c:otherwise>
			</c:choose>

			<git:organization ID="${orgid}">
				<h2>
					<git:organizationName />
				</h2>
				
				<c:if test="${not empty param.sid}">
                    <h3>Rank: ${rank} - <a href="judgeOrganization.jsp?relevant=true&sid=${param.sid}&orgid=${orgid}">relevant</a> - <a href="judgeOrganization.jsp?relevant=false&sid=${param.sid}&orgid=${orgid}">non-relevant</a></h3>
				</c:if>

				<p>
					<b>Login:</b>
					<git:organizationLogin />
				</p>
				<p>
					<b>Company:</b>
					<git:organizationCompany />
				</p>
				<p>
					<b>Location:</b>
					<git:organizationLocation />
				</p>
				<p>
					<b>email:</b>
					<git:organizationEmail />
				</p>
            <p><b>Blog:</b>
            <c:choose>
            <c:when test="${fn:startsWith(git:organizationBlogValue(),'http')}">
             <a href="<git:organizationBlog/>"><git:organizationBlog/></a>
            </c:when>
            <c:otherwise>
             <a href="http://<git:organizationBlog/>"><git:organizationBlog/></a>
            </c:otherwise>
            </c:choose>
            </p>

				<c:if test="${git:organizationHasMember(orgid)}">
					<h3>Members</h3>
					<ol class="bulletedList">
						<git:foreachMember var="x" useUser="true" sortCriteria="name">
							<git:member>
								<c:set var="uid" value="${git:memberUserIdValue()}" />
								<git:user ID="${uid}">
									<li><a href="<util:applicationRoot/>/user/user.jsp?id=<git:userID/>"><git:userName /></a>
								</git:user>
							</git:member>
						</git:foreachMember>
					</ol>
				</c:if>

				<h3>Repositories</h3>
    			<dl>
				<git:foreachOrgRepo var="x" useRepository="true" sortCriteria="name">
					<git:orgRepo>
						<c:set var="rid" value="${git:orgRepoRepositoryIdValue()}" />
						<git:repository ID="${rid}">
							<dt>
								<a
									href="<util:applicationRoot/>/repository/repository.jsp?id=<git:repositoryID/>"><git:repositoryName /></a>
							</dt>
							<dd>
								<git:repositoryDescription />
							</dd>
						</git:repository>
					</git:orgRepo>
				</git:foreachOrgRepo>
			</dl>

            </git:organization>
            </div>
            <div style="width: 100%; float: left">
                <jsp:include page="../footer.jsp" flush="true" />
            </div>
        </div>
    </div>
</body>

</html>


