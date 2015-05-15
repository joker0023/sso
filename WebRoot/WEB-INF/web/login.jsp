<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="renderer" content="webkit">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>登录</title>
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
				position: absolute;
				right: 0;
			}
			.form-signin {
			    margin: 0 auto;
			    max-width: 350px;
			    padding-bottom: 20px;;
			    border: 1px solid #CFDAE6;
			    border-radius: 10px;
			    box-shadow: 0 1px 1px #E6EFF2;
			    background-color: #F7FCFF;
			}
			.form-signin-activite {
				 box-shadow : 1px 1px 5px #CCCCCC,
			    			 1px -1px 5px #CCCCCC,
			    			 -1px 1px 5px #CCCCCC,
			    			 -1px -1px 5px #CCCCCC;
			}
			.form-signin .form-signin-head {
				border-radius: 10px 10px 0 0;
				border-bottom: 1px solid #CFDAE6;
				background-color: #F3F8FF;
				background: linear-gradient(to bottom, #F7FCFF, #F3F8FF, #F7FCFF);
				height: 50px;
				line-height: 50px;
				text-align: left;
				font-size: 27px;
				font-weight: bold;
				color: #428BCA;
				padding-left: 45px;
			}
			.form-signin .form-signin-body {
				width: 250px;
				margin: 0 auto;
			}
			.authCode {
				width: 100px;
				display: inline-block;
			}
			#authCodeImg {
				cursor: pointer;
			}
			.remember {
				display: inline-block;
				padding-left: 20px;
			}
			.forget {
				color: #CCC;
				cursor: pointer;
				display: inline-block;
				float: right;
			}
			.control-label {
				margin-bottom: 0;
				display: none;
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
			
			@media screen and (max-width: 500px) {
				.footer{
					display: none;
				}
				.signin-container {
					padding: 10px 0px 0px;
				}
				.form-signin {
				    max-width: none;
				    border: 0;
				    border-radius: 0px;
				    box-shadow: none;
				}
				.form-signin .form-signin-body > div {
					padding: 0 15px;
				}
				.form-signin .form-signin-head {
					border-radius: 0;
					padding-left: 15px;
				}
				.form-signin .form-signin-body {
					width: auto;
				}
			}
		</style>
	</head>
	<body>
		<div class="signin-container col-xs-12 col-sm-9 col-md-7">
			<form action="${pageContext.request.contextPath }/validation/web_login_handle.do" class="form-signin form-signin-activite" method="post">
				<div class="form-signin-head">
					~登~录~
				</div>
				<div class="form-signin-body">
					<div class="errLabel">
						<label class="control-label" for="inputError">Input with error</label>
					</div>
					<div class="form-group">
  						<input type="email" class="form-control" name="account" placeholder="账号" autofocus value="${requestScope.data.account}">
					</div>
					<div class="form-group">
  						<input type="password" class="form-control" name="password" placeholder="密码" autocomplete="off">
					</div>
					<c:if test="${null != data.authCodeName }">
						<div class="form-group">
							<input type="text" class="form-control authCode" name="authCode" placeholder="验证码" autocomplete="off">
							<img id="authCodeImg" src="" alt="验证码" title="换一张">
						</div>
					</c:if>
					<div class="form-group">
						<label class="checkbox">
							<span class="remember"><input type="checkbox" value="记住我" name="remember" id="remember">记住我</span>
							<span class="forget"><a href="${pageContext.request.contextPath }/validation/findPwd.do">忘记密码</a></span>
						</label>
					</div>
					<div class="form-group">
						<table style="width: 100%;">
							<tr>
								<td style="width: 50%;padding-right: 10px;">
									<button class="btn btn-lg btn-primary btn-block" type="submit">登录</button>
								</td>
								<td style="width: 50%;padding-left: 10px;">
									<a class="btn btn-lg btn-success btn-block" href="${pageContext.request.contextPath }/validation/registered.do">注册</a>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</form>
		</div>
		<div class="footer"></div>
	</body>
	
	<script src="${pageContext.request.contextPath }/assets/js/jquery-1.10.2.min.js"></script>
	<script src="${pageContext.request.contextPath }/assets/js/jquery.cookie.js"></script>
	<script src="${pageContext.request.contextPath }/assets/js/bootstrap.js"></script>
	<script src="${pageContext.request.contextPath }/assets/js/aes.js"></script>
	<script type="text/javascript">
		$(function(){
			$(".signin-container").css("height",$(document).height());
			
			var authCodeName = "${data.authCodeName}";
			if(null != authCodeName && authCodeName != ""){
				$("#authCodeImg").click(function(){
					$("#authCodeImg").attr("src", "${pageContext.request.contextPath}/validation/web_getAuthCode.do?authCodeName=" + authCodeName + "&t=" + new Date().getTime());
				});
				$("#authCodeImg").trigger("click");
			}
			
			var loginPwd = "${requestScope.data.loginPwd}";
			for(var i = 0; i < 16; i++){
				loginPwd += String.fromCharCode(0);
			}
			loginPwd = loginPwd.substring(0, 16);
			
			// 出错信息
			var errMsg = "${requestScope.data.errMsg}";
			if(null != errMsg && errMsg != ""){
				$("input[name='account']").parent().addClass("has-error");
				$(".control-label").text(errMsg);
				$(".control-label").show();
			}
			
			// cookie
			var cookie101 = $.cookie("cookie101");	//account
			var cookie102 = $.cookie("cookie102");	//password
			if(null != cookie101 && null != cookie101){
				$("#remember").attr("checked",true);
				$("input[name='account']").val(cookie101);
				$("input[name='password']").val(cookie102);
			}
			
			// 事件
			$("input").click(function(){
				$(".control-label").hide();
				$(".form-group").removeClass("has-error");
			});
			
			$(".form-signin").click(function(event){
				if(typeof event.stopPropagation != "undefined" ){
			   		event.stopPropagation();
			    } else{
			    	event.cancelBubble = true;
			    }
				$(this).addClass("form-signin-activite");
			});
			
			$("body").click(function(){
				$(".form-signin").removeClass("form-signin-activite");
			});
			
			// 表单提交校验
			$("form").submit(function(){
				var account = $("input[name='account']").val();
				var password = $("input[name='password']").val();
				
				var checkMsg = "";
				var checkType = 0;
				if(null == account || "" == $.trim(account)){
					checkType = 1;
					checkMsg = "账号不能为空";
				}else if(!/^([\w\-])+(\.[\w\-]+)*@([\w\-]+\.)+([a-z]){2,4}$/.test(account)){
					checkType = 1;
					checkMsg = "账号只能是email地址";
				}else if(null == password || "" == $.trim(password)){
					checkType = 2;
					checkMsg = "密码不能为空";
				}else if(password.length < 6){
					checkType = 2;
					checkMsg = "密码长度应为6~12位";
				}else if(!/^\w+$/.test(password)){
					checkType = 2;
					checkMsg = "密码只能是数字或字母";
				}else if($("input[name='authCode']").length > 0){
					var authCode = $("input[name='authCode']").val();
					if(null == authCode || $.trim(authCode) == ""){
						checkType = 3;
						checkMsg = "验证码不能为空";
					}
				}
				
				if(checkType == 1){
					$("input[name='account']").focus();
					$("input[name='account']").parent().addClass("has-error");
					$(".control-label").text(checkMsg);
					$(".control-label").show();
					return false;
				}else if(checkType == 2){
					$("input[name='password']").focus();
					$("input[name='password']").parent().addClass("has-error");
					$(".control-label").text(checkMsg);
					$(".control-label").show();
					return false;
				}else if(checkType == 3){
					$("input[name='authCode']").focus();
					$("input[name='authCode']").parent().addClass("has-error");
					$(".control-label").text(checkMsg);
					$(".control-label").show();
					return false;
				}
				
				if(password.length < 32){
					//加密
					var key = CryptoJS.enc.Utf8.parse(loginPwd);
			    	var iv  = CryptoJS.enc.Utf8.parse("0102030405060708");
			    	var encrypted = CryptoJS.AES.encrypt(password, key, { iv: iv,mode:CryptoJS.mode.CBC});
					password = encrypted.ciphertext.toString();
					$("input[name='password']").val(password);
				}
				//记住密码
				if($("#remember").is(":checked")){
					$.cookie("cookie101", account, {expires: 7, path: '/'})
					$.cookie("cookie102", password, {expires: 7, path: '/'})
				}else{
					$.cookie("cookie101", account, {expires: -1, path: '/'})
					$.cookie("cookie102", password, {expires: -1, path: '/'})
				}
				return true;
			});
			
		});
		
	</script>
</html>