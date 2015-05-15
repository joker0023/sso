<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>找回密码</title>
		<link rel="shortcut icon" href="${pageContext.request.contextPath }/favicon.ico">
		<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/bootstrap.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/base.css">
		<style type="text/css">
			body {
				min-width: 200px;
				min-height: 1px;
				position: relative;
			}
			.signin-container {
				border-left: #ccc 1px solid;
				padding-top: 100px;
				min-width: 200px;
				position: absolute;
				right: 0;
			}
			.form-signin {
				padding: 0 30px;
			}
			.form-signin .form-signin-head {
				border-bottom: 1px solid #CFDAE6;
				height: 50px;
				line-height: 50px;
				text-align: left;
				font-size: 27px;
				font-weight: bold;
				color: #428BCA;
			}
			.form-signin .form-signin-body {
				
			}
			.form-horizontal .control-label {
				text-align: left;
				display: none;
			}
			#authCodeImg {
				cursor: pointer;
			}
			.errLabel {
				height: 30px;
				color: #a94442;
				line-height: 30px;
			}
			.alert {
				border: 1px solid #ccc;
				width: 80%;
				margin: 10px auto;
			}
			.footer {
				border-top: solid #ccc 1px;
				position: absolute;
				top: 500px;
				width: 100%;
			}
			
			@media screen and (max-width: 750px) {
				.footer {
					display: none;
				}
				.signin-container {
					border: 0;
				}
			}
			
			@media screen and (max-width: 400px) {
				.form-signin {
					padding: 0;
				}
				.signin-container {
					padding: 10px 0px 0px;
				}
				.form-horizontal .form-group {
					margin-left: 0;
					margin-right: 0;
				}
				.form-signin .form-signin-head {
					padding-left: 15px;
				}
			}
		</style>
	</head>
	<body>
		<div class="signin-container col-xs-12 col-sm-9 col-md-7">
			<form action="${pageContext.request.contextPath }/validation/web_findPwd_handle.do" class="form-signin form-horizontal" method="post">
				<div class="form-signin-head">
					~找回密码~
				</div>
				<div class="form-signin-body">
					<div class="form-group errLabel">
						<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
						 	<label class="control-label" for="inputError">Input with error</label>
						</div>
					</div>
					<div class="form-group">
					    <div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
					    	<input id="account" type="text" class="form-control" name="account" required="required"
					    	 placeholder="账号(email)" autofocus value="${requestScope.data.account}">
					    </div>
					</div>
					<div class="form-group">
						<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
							<input id="authCode" type="text" class="form-control" name="authCode" required="required"
						    	 placeholder="验证码" autocomplete="off" style="width: 100px; display: inline-block; margin-bottom: 5px;">
					    	<img id="authCodeImg" src="" alt="验证码" title="换一张">
					    </div>
					</div>
					<div class="form-group">
						<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
							<button class="btn btn-lg btn-primary btn-block" type="submit">确定</button>
						</div>
					</div>
				</div>
			</form>
		</div>
		<div class="footer"></div>
	</body>
	
	<script src="${pageContext.request.contextPath }/assets/js/jquery-1.10.2.min.js"></script>
	<script src="${pageContext.request.contextPath }/assets/js/bootstrap.js"></script>
	<script type="text/javascript">
		$(function(){
			$(".signin-container").css("height",$(document).height());
			
			var errMsg = "${requestScope.data.errMsg}";
			if(null != errMsg && "" != errMsg){
				$(".control-label").text(errMsg);
				$(".control-label").show();
			}
			
			var authCodeName = "${requestScope.data.authCodeName}";
			
			$("#authCodeImg").click(function(){
				$("#authCodeImg").attr("src", "${pageContext.request.contextPath}/validation/web_getAuthCode.do?authCodeName=" + authCodeName + "&t=" + new Date().getTime());
			});
			
			$("#authCodeImg").trigger("click");
			
			$(".form-group input").focus(function(){
				$(".control-label").hide();
			});
			
			$("form").submit(function(){
				var account = $("#account").val();
				var authCode = $("#authCode").val();
				if(null == account || "" == account){
					$(".control-label").text("账号不能为空");
					$(".control-label").show();
					return false;
				}else if(!/^([\w\-])+(\.[\w\-]+)*@([\w\-]+\.)+([a-z]){2,4}$/.test(account)){
					$(".control-label").text("请输入正确的email地址");
					$(".control-label").show();
					return false;
				}else if(null == authCode || "" == authCode){
					$(".control-label").text("验证码不能为空");
					$(".control-label").show();
					return false;
				}
				return true;
			});
		});
	</script>
</html>