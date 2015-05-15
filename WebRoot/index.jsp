<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
  <head>
  	<meta charset="utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> -->
    <title>SSO</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath }/favicon.ico">
    <style type="text/css">
    	ul li {
    		margin-top: 5px;
    	}
    </style>
  </head>
  
  <body>
	<h2>SSO page...</h2>
	<c:if test="${null != webUser}">
		<h3>用户: ${webUser.account }</h3>
		<br>
		<a href="${pageContext.request.contextPath }/validation/logout.do">退出</a>
	</c:if>
	<c:if test="${null == webUser}">
		<ul>
			<li>
				<a href="${pageContext.request.contextPath }/validation/login.do">登录</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath }/validation/registered.do">注册</a>
			</li>
		</ul>
	</c:if>
  </body>
</html>
