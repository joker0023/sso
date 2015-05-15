<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>修改密码</title>
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
			.btn {
				padding: 10px 42px;
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
			<form action="${pageContext.request.contextPath }/validation/web_changePwd_handle.do" class="form-signin form-horizontal" method="post">
				<div class="form-signin-head">
					~修改密码~
				</div>
				<div class="form-signin-body">
					<div class="form-group errLabel">
						<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
						 	<label class="control-label" for="inputError">Input with error</label>
						</div>
					</div>
					<div class="form-group">
						<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
					    	<input id="password" type="password" class="form-control" name="password" 
					    	 required="required" placeholder="密码(6~12位)" autocomplete="off">
					    </div>
					</div>
					<div class="form-group">
						<div class="col-xs-12 col-sm-8 col-md-7 col-lg-6">
					    	<input id="confirmPassword" type="password" class="form-control" name="confirmPassword" 
					    	 required="required" placeholder="确认密码(6~12位)" autocomplete="off">
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
			
			$(".form-group input").focus(function(){
				$(".control-label").hide();
			});
			
			$("form").submit(function(){
				var password = $("#password").val();
				var confirmPassword = $("#confirmPassword").val();
				
				if(null == password || "" == password || password.length < 6 || password.length > 12){
					$(".control-label").text("密码长度应为6~12位");
					$(".control-label").show();
					return false;
				}else if(!/^\w+$/.test(password)){
					$(".control-label").text("密码只能是数字或字母");
					$(".control-label").show();
					return false;
				}else if(confirmPassword != password){
					$(".control-label").text("两次密码不一致");
					$(".control-label").show();
					return false;
				}
				return true;
			});
		});
	</script>
</html>