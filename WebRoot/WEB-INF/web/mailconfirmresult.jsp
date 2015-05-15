<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>邮件检验</title>
		<link rel="shortcut icon" href="${pageContext.request.contextPath }/favicon.ico">
		<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/bootstrap.css">
		<style type="text/css">
			.alert {
				border: 1px solid #ccc;
				margin-top: 10px;
			}
		</style>
	</head>
	<body>
		<div class="container">
			<c:if test="${requestScope.data.confirmResult == 'success' }">
				<div class="alert alert-success">
					校验成功: ${requestScope.data.confirmMsg }
				</div>
			</c:if>
			<c:if test="${requestScope.data.confirmResult == 'fail' }">
				<div class="alert alert-danger">
					 ${requestScope.data.confirmMsg }
				</div>
			</c:if>
		</div>
		
		<script src="${pageContext.request.contextPath }/assets/js/jquery-1.10.2.min.js"></script>
		<script src="${pageContext.request.contextPath }/assets/js/bootstrap.js"></script>
	</body>
</html>
 