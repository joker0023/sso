<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>注册</title>
		<link rel="shortcut icon" href="${pageContext.request.contextPath }/favicon.ico">
		<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/bootstrap.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/css/base.css">
		<style type="text/css">
			body{ 
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
				margin-bottom: 20px;
			}
			.form-signin .form-signin-body {
				
			}
			.form-horizontal .control-label {
				text-align: left;
				display: none;
			}
			.glyphicon {
				display: none;
			}
			#authCodeImg {
				cursor: pointer;
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
			<form action="${pageContext.request.contextPath }/validation/web_registered_handle.do" class="form-signin form-horizontal" method="post">
				<div class="form-signin-head">
					~注~册~
				</div>
				<div class="form-signin-body">
					<div class="form-group has-feedback">
					    <div class="col-xs-12 col-sm-9 col-md-8 col-lg-7">
					    	<input id="account" type="text" class="form-control" name="account" required="required"
					    	 placeholder="账号(email)" autofocus value="${requestScope.data.account}">
					    	<span class="glyphicon glyphicon-ok form-control-feedback"></span>
					    </div>
  						<label class="control-label col-sm-3" for="account">Input with error</label>
					</div>
					<div class="form-group has-feedback">
						<div class="col-xs-12 col-sm-9 col-md-8 col-lg-7">
					    	<input id="password" type="password" class="form-control" name="password" 
					    	 required="required" placeholder="密码(6~12位)" autocomplete="off">
					    	<span class="glyphicon glyphicon-ok form-control-feedback"></span>
					    </div>
  						<label class="control-label col-sm-3" for="password">Input with error</label>
					</div>
					<div class="form-group has-feedback">
						<div class="col-xs-12 col-sm-9 col-md-8 col-lg-7">
					    	<input id="confirmPassword" type="password" class="form-control" name="confirmPassword" 
					    	 required="required" placeholder="确认密码(6~12位)" autocomplete="off">
					    	<span class="glyphicon glyphicon-ok form-control-feedback"></span>
					    </div>
  						<label class="control-label col-sm-3" for="confirmPassword">Input with error</label>
					</div>
					<div class="form-group has-feedback">
						<div class="col-xs-12 col-sm-9 col-md-8 col-lg-7">
							<input id="authCode" type="text" class="form-control" name="authCode" 
						    	 required="required" placeholder="验证码" autocomplete="off" style="width: 120px; display: inline-block;margin-bottom: 5px;">
						    	<span class="glyphicon glyphicon-ok form-control-feedback" style="left: 100px;"></span>
					    	<img id="authCodeImg" src="" alt="验证码" title="换一张">
					    </div>
  						<label class="control-label col-sm-3" for="confirmPassword">Input with error</label>
					</div>
					<div class="form-group">
						<div class="col-xs-12 col-sm-9 col-md-8 col-lg-7">
							<table style="width: 100%;">
								<tr>
									<td style="width: 50%;padding-right: 10px;">
									<button class="btn btn-lg btn-primary btn-block" type="submit">注册</button>
									</td>
									<td style="width: 50%;padding-left: 10px;">
										<a class="btn btn-lg btn-success btn-block" id="login-btn" href="${pageContext.request.contextPath }/validation/login.do">登录</a>
									</td>
								</tr>
							</table>
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
				alert(errMsg);
			}
			
			var authCodeName = "${requestScope.data.authCodeName}";
			
			$("#authCodeImg").click(function(){
				$("#authCodeImg").attr("src", "${pageContext.request.contextPath}/validation/web_getAuthCode.do?authCodeName=" + authCodeName + "&t=" + new Date().getTime());
			});
			
			$("#authCodeImg").trigger("click");
			
			$(".form-group input").focus(function(){
				var $this = $(this);
				$this.parents(".form-group").removeClass("has-success").removeClass("has-error");
				$this.next("span").hide();
				$this.parent().next("label").hide();
			});
			
			$("#account").blur(function(){
				var $this = $(this);
				var value = $this.val();
				
				var checkResult = true;
				var checkMsg = "";
				if(null == value || "" == value){
					checkResult = false;
					checkMsg = "账号不能为空";
				}else if(!/^([\w\-])+(\.[\w\-]+)*@([\w\-]+\.)+([a-z]){2,4}$/.test(value)){
					checkResult = false;
					checkMsg = "请输入正确的email地址";
				}else{
					$.ajax({
						async: false,
						type: "post",
						url: "${pageContext.request.contextPath }/validation/web_checkAccount.do",
						data: {
							"account": value
						},
						dataType: "json",
						success: function(msg){
							if(null != msg && null != msg.checkMsg){
								checkResult = false;
								checkMsg = msg.checkMsg;
							}
						},
						error: function(e){
							alert(e);
						}
					});
				}
				
				if(checkResult){
					$this.parents(".form-group").addClass("has-success");
					$this.next("span").show();
				}else{
					$this.parents(".form-group").addClass("has-error");
					$this.parent().next("label").text(checkMsg);
					$this.parent().next("label").show();
				}
			});
			
			$("#password").blur(function(){
				var $this = $(this);
				var value = $this.val();
				
				var checkResult = true;
				var checkMsg = "";
				if(null == value || "" == value || value.length < 6 || value.length > 12){
					checkResult = false;
					checkMsg = "密码长度应为6~12位";
				}else if(!/^\w+$/.test(value)){
					checkResult = false;
					checkMsg = "密码只能是数字或字母";
				}
				
				if(checkResult){
					$this.parents(".form-group").addClass("has-success");
					$this.next("span").show();
				}else{
					$this.parents(".form-group").addClass("has-error");
					$this.parent().next("label").text(checkMsg);
					$this.parent().next("label").show();
				}
				
			});
			
			$("#confirmPassword").blur(function(){
				var $this = $(this);
				var value = $this.val();
				var oriPwd = $("#password").val();
				
				if(value == oriPwd){
					$this.parents(".form-group").addClass("has-success");
					$this.next("span").show();
				}else{
					$this.parents(".form-group").addClass("has-error");
					$this.parent().next("label").text("两次密码输入不一致");
					$this.parent().next("label").show();
				}
			});
			
			$("#authCode").blur(function(){
				var $this = $(this);
				var value = $this.val();
				
				var checkResult = true;
				var checkMsg = "";
				if(null == value || "" == value){
					checkResult = false;
					checkMsg = "验证码不能为空";
				}else{
					$.ajax({
						async: false,
						type: "post",
						url: "${pageContext.request.contextPath }/validation/web_checkAuthCode.do",
						data: {
							"authCodeName": authCodeName,
							"authCode": value
						},
						dataType: "json",
						success: function(msg){
							console.log(msg);
							if(null == msg || null == msg.checkResult || msg.checkResult != "ok"){
								checkResult = false;
								checkMsg = "验证码错误";
							}
						},
						error: function(e){
							alert(e);
						}
					});
				}
				
				console.log(checkResult);
				if(checkResult){
					$this.parents(".form-group").addClass("has-success");
					$this.next("span").show();
				}else{
					$this.parents(".form-group").addClass("has-error");
					$this.parent().next("label").text(checkMsg);
					$this.parent().next("label").show();
				}
			});
			
			$("form").submit(function(){
				$(".form-group input").trigger("blur");
				
				if($(".form-group.has-error").length > 0){
					return false;
				}
				
				return true;
			});
			
		});
	</script>
</html>