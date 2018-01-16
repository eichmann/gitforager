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
			<git:organization ID="${param.id}">
				<h2>
					<git:organizationName />
				</h2>

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

				<c:if test="${git:organizationHasMember(param.id)}">
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

			<jsp:include page="/footer.jsp" flush="true" /></div>
	</div>
</body>
</html>

