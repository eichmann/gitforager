<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
			<git:searchTerm ID="${param.id}">
            <h2>Search: <git:searchTermTerm/></h2>
            
            <c:choose>
            <c:when test="${param.showAll}">
                [<a href="search.jsp?id=${param.id}">hide non-relevant results</a>]<p>
            </c:when>
            <c:otherwise>
                [<a href="search.jsp?id=${param.id}&showAll=true">show non-relevant results</a>]<p>
            </c:otherwise>
            </c:choose>
            
            <h3><a href="graph.jsp?id=${param.id}">Visualization</a></h3>
            <p>
            <h3>Repositories</h3>
            <ol class="bulletedList">
            <git:foreachSearchRepository var="x" useRepository="true" >
                <git:searchRepository>
                    <c:if test="${git:searchRepositoryRelevantValue() || param.showAll}">
                        <c:set var="rid" value="${git:searchRepositoryRidValue()}"/>
                        <git:repository ID="${rid}">
                            <li><a href="<util:applicationRoot/>/repository/repository.jsp?id=<git:repositoryID/>"><git:repositoryFullName/></a>
                        </git:repository>
                    </c:if>
                 </git:searchRepository>
            </git:foreachSearchRepository>
            </ol>
            
            <h3>Users</h3>
            <ol class="bulletedList">
            <git:foreachSearchUser var="x" useUser="true">
                <git:searchUser>
                    <c:if test="${git:searchUserRelevantValue() || param.showAll}">
                     <c:set var="uid" value="${git:searchUserUidValue()}"/>
                        <git:user ID="${uid}">
                            <c:choose>
                            <c:when test="${empty git:userNameValue() }">
                                <li><a href="<util:applicationRoot/>/user/user.jsp?id=<git:userID/>"><git:userLogin/></a>
                            </c:when>
                            <c:otherwise>
                                 <li><a href="<util:applicationRoot/>/user/user.jsp?id=<git:userID/>"><git:userName/></a>
                           </c:otherwise>
                            </c:choose>
                        </git:user>
                    </c:if>
                </git:searchUser>
            </git:foreachSearchUser>
            </ol>
            
            <h3>Organizations</h3>
            <ol class="bulletedList">
            <git:foreachSearchOrganization var="x" useOrganization="true">
                <git:searchOrganization>
                    <c:if test="${git:searchOrganizationRelevantValue() || param.showAll}">
                        <c:set var="orgid" value="${git:searchOrganizationOrgidValue()}"/>
                        <git:organization ID="${orgid}">
                            <c:choose>
                            <c:when test="${empty git:organizationNameValue() }">
                                <li><a href="<util:applicationRoot/>/organization/organization.jsp?id=<git:organizationID/>"><git:organizationLogin/></a>
                            </c:when>
                            <c:otherwise>
                                <li><a href="<util:applicationRoot/>/organization/organization.jsp?id=<git:organizationID/>"><git:organizationName/></a>
                            </c:otherwise>
                            </c:choose>
                        </git:organization>
                    </c:if>
                </git:searchOrganization>
            </git:foreachSearchOrganization>
            </ol>
            
			</git:searchTerm>
            </div>
            <div style="width: 100%; float: left">
                <jsp:include page="../footer.jsp" flush="true" />
            </div>
        </div>
    </div>
</body>

</html>

