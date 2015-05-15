package com.jokerstation.sso.action.validation;

import java.io.InputStream;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.Date;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.jokerstation.base.action.BaseAction;
import com.jokerstation.base.data.BaseData;
import com.jokerstation.base.util.ImageUtil;
import com.jokerstation.base.util.PasswordUtil;
import com.jokerstation.base.util.ValidationUtil;
import com.jokerstation.sso.dao.WebUserDao;
import com.jokerstation.sso.dao.WebUserInfoDao;
import com.jokerstation.sso.data.Data;
import com.jokerstation.sso.service.LoginSessionService;
import com.jokerstation.sso.vo.WebUser;
import com.jokerstation.sso.vo.WebUserInfo;

/**
 * 登录模块
 * @author Joker
 *
 */
public class ValidationAction extends BaseAction {

	private static final long serialVersionUID = -9006306966034977620L;
	
	private static final Logger logger = Logger.getLogger(ValidationAction.class);
	
	private static final String PWD = "joker";	//邮件内容加密密钥
	private static final String LOGIN_PWD = "login";	//登录密码加密密钥
	
	private static final String WEB_LOGIN = "web_login";
	private static final String WEB_LOGOUT = "web_logout";
	private static final String WEB_REGISTERED = "web_registered";
	private static final String WEB_FINDPWD = "web_findpwd";
	private static final String WEB_CHANGEPWD = "web_changepwd";
	private static final String WEB_LOGIN_OK = "web_login_ok";
	private static final String WEB_MAIL_CONFIRM = "web_mail_confirm";
	
	public static final String[] AuthCodeNames = {"registered_authcode", "changePwd_authcode", "login_authcode"};
	private static final int maxLoginCount = 3;
	
	/**
	 * 跳转前台登陆页面
	 * @return
	 */
	public String login(){
		WebUser webUser = (WebUser)request.getSession().getAttribute("webUser");
		if(null != webUser){
			return WEB_LOGIN_OK;
		}else{
			Integer count = (Integer)request.getSession().getAttribute("login_count");
			count = null == count ? 0 : count;
			
//			System.out.println("count : " + count);
			if(count > maxLoginCount){
				setAttribute("authCodeName", AuthCodeNames[2]);
			}
			setAttribute("loginPwd", LOGIN_PWD);
			return WEB_LOGIN;
		}
	}
	
	/**
	 * 前台登出
	 * @return
	 */
	public String logout(){
		LoginSessionService.logoutOkHandle(request);
		
		return WEB_LOGOUT;
	}
	
	/**
	 * 前台注册
	 * @return
	 */
	public String registered(){
		setAttribute("authCodeName", AuthCodeNames[0]);
		return WEB_REGISTERED;
	}
	
	/**
	 * 前台登陆处理
	 * @return
	 */
	public String web_login_handle(){
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		
		try{
			setAttribute("account", account);
			if(StringUtils.isBlank(account) || StringUtils.isBlank(password)){
				setAttribute("errMsg", "字段不能为空");
			}else if(!ValidationUtil.isEmail(account)){
				setAttribute("errMsg", "账号必须是email地址");
			}else if(ValidationUtil.isSQLInjection(account)){
				setAttribute("errMsg", "账号非法");
			}else if(ValidationUtil.isSQLInjection(password)){
				setAttribute("errMsg", "密码只能为数字和大小写字母");
			}else{
				Integer count = (Integer)request.getSession().getAttribute("login_count");
				count = null == count ? 0 : count;
				if(count > maxLoginCount){
					String authCode = request.getParameter("authCode");
					String sessionAuthCode = (String)request.getSession().getAttribute(AuthCodeNames[2]);
					if(StringUtils.isBlank(authCode)){
						setAttribute("errMsg", "验证码不能为空");
						return login();
					}
					if(null == sessionAuthCode || !authCode.toLowerCase().equals(sessionAuthCode.toLowerCase())){
						setAttribute("errMsg", "验证码错误");
						return login();
					}
				}
				count++;
				request.getSession().setAttribute("login_count", count);
				
				//校验成功,开始登陆
				try{
					// AES解密得到原始密码
					password = PasswordUtil.AESDecrypt(password, LOGIN_PWD);
				}catch (Exception e) {
					e.printStackTrace();
					setAttribute("errMsg", "用户或密码错误");
				}
				
				WebUser webUser = new WebUserDao().getWebUser(account);
				if(null != webUser && PasswordUtil.MD5(password).equals(webUser.getPassword())){
					// 登陆成功,后续处理
					WebUserInfoDao webUserInfoDao = new WebUserInfoDao();
					WebUserInfo webUserInfo = webUserInfoDao.getByUid(webUser.getId());
					if(null != webUserInfo){
						webUserInfo.setLastLoginIp(getIpAddr());
						webUserInfo.setLastLoginTime(new Date());
						webUserInfoDao.update(webUserInfo);
					}else{
						webUserInfo = new WebUserInfo();
						webUserInfo.setUid(webUser.getId());
						webUserInfo.setNick(webUser.getAccount());
						webUserInfo.setGrade(WebUserInfo.NORMAL);
						webUserInfo.setIntegral(0);
						webUserInfo.setEmail(webUser.getAccount());
						webUserInfo.setLastLoginIp(getIpAddr());
						webUserInfo.setCreateTime(new Date());
						webUserInfo.setLastLoginTime(new Date());
						webUserInfo.setAvatar(Data.defAvatar);
						long id = new WebUserInfoDao().save(webUserInfo);
						webUserInfo.setId(id);
					}
					
					LoginSessionService.loginOkHandle(request, webUser, webUserInfo);
					request.getSession().setAttribute("login_count", 0);
					
					return WEB_LOGIN_OK;
				}else{
					setAttribute("errMsg", "用户或密码错误");
				}
			}
		}catch (Exception e) {
			logger.error("登陆出错." ,e);
			setAttribute("errMsg", "服务器出错");
		}
		
		return login();
	}
	
	/**
	 * 前台注册处理
	 * @return
	 */
	public String web_registered_handle(){
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		
		try{
			if(checkRegisteredData()){
				WebUser webUser = new WebUser();
				webUser.setAccount(account);
				webUser.setPassword(PasswordUtil.MD5(password));
				webUser.setState(WebUser.STATE_UNACTIVE);
				long uid = new WebUserDao().save(webUser);
				webUser.setId(uid);
				
				// 注册成功,后续处理
				WebUserInfo webUserInfo = new WebUserInfo();
				webUserInfo.setUid(uid);
				webUserInfo.setNick(webUser.getAccount());
				webUserInfo.setGrade(WebUserInfo.NORMAL);
				webUserInfo.setIntegral(0);
				webUserInfo.setEmail(webUser.getAccount());
				webUserInfo.setLastLoginIp(getIpAddr());
				webUserInfo.setCreateTime(new Date());
				webUserInfo.setLastLoginTime(new Date());
				webUserInfo.setAvatar(Data.defAvatar);
				long userinfoId = new WebUserInfoDao().save(webUserInfo);
				webUserInfo.setId(userinfoId);
				
				LoginSessionService.registeredOkHandle(request, webUser, webUserInfo);
				
				// 发送邮件确认
				web_sendMailConfirm_forRegistered();
				
				return WEB_LOGIN_OK;
			}
		}catch (Exception e) {
			logger.error("注册出错", e);
		}
		
		return registered();
	}
	
	/**
	 * 校验前台注册信息
	 * @return
	 * @throws SQLException
	 */
	private boolean checkRegisteredData() throws SQLException{
		String authCodeName = AuthCodeNames[0];
		
		String account = request.getParameter("account");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String authCode = request.getParameter("authCode");
		
		if(null == account || null == password || null == confirmPassword || null == authCode){
			setAttribute("errMsg", "注册失败,字段不能为空");
			return false;
		}
		
		if(!ValidationUtil.isEmail(account)){
			setAttribute("errMsg", "账号必须是email地址");
			return false;
		}
		
		if(ValidationUtil.isSQLInjection(account)){
			setAttribute("errMsg", "账号非法");
			return false;
		}
		
		WebUser webUser = new WebUserDao().getWebUser(account);
		if(null != webUser){
			setAttribute("errMsg", "账号已存在");
			return false;
		}
		
		if(ValidationUtil.isSQLInjection(password)){
			setAttribute("errMsg", "密码只能为数字和大小写字母");
			return false;
		}
		
		if(password.length() < 6 || password.length() > 12){
			setAttribute("errMsg", "密码长度应在6~12位之间");
			return false;
		}
		
		if(!password.equals(confirmPassword)){
			setAttribute("errMsg", "两次密码输入不一致");
			return false;
		}
		
		if(null == request.getSession().getAttribute(authCodeName) || 
				!authCode.toLowerCase().equals(request.getSession().getAttribute(authCodeName).toString().toLowerCase())){
			setAttribute("errMsg", "验证码错误");
			return false;
		}
		
		return true;
	}
	
	/**
	 * 检验前台登陆账号
	 */
	public void web_checkAccount(){
		try{
			String account = request.getParameter("account");
			if(null == account || ValidationUtil.isSQLInjection(account)){
				setJSONAttribute("checkMsg", "账号非法");
			}else{
				WebUser webUser = new WebUserDao().getWebUser(account);
				if(null != webUser){
					setJSONAttribute("checkMsg", "账号已存在");
				}
			}
			
			flushJSONData();
		}catch (Exception e) {
			logger.error("", e);
		}
	}
	
	/**
	 * 校验验证码
	 */
	public void web_checkAuthCode(){
		try{
			String authCodeName = request.getParameter("authCodeName");
			String authCode = request.getParameter("authCode");
			
			if(null == authCodeName || null == authCode){
				setJSONAttribute("checkResult", "fail");
			}else if(null == request.getSession().getAttribute(authCodeName)){
				setJSONAttribute("checkResult", "fail");
			}else if(!authCode.toLowerCase().equals(request.getSession().getAttribute(authCodeName).toString().toLowerCase())){
				setJSONAttribute("checkResult", "fail");
			}else{
				setJSONAttribute("checkResult", "ok");
			}
			
			flushJSONData();
		}catch (Exception e) {
			logger.error("", e);
		}
	}
	
	/**
	 * 发送邮件检验(注册后账号激活)
	 */
	public void web_sendMailConfirm_forRegistered(){
		try{
			WebUser webUser = (WebUser)request.getSession().getAttribute("webUser");
			if(null != webUser){
				String url = getRootHostUrl() + "/validation/web_mailConfirmHandle_forRegistered.do";
				url += "?a1=" + URLEncoder.encode(PasswordUtil.MD5(webUser.getAccount()), "UTF-8");
				url += "&a2=" + URLEncoder.encode(PasswordUtil.AESEncrypt(webUser.getAccount(), PWD), "UTF-8");
				url += "&a3=" + URLEncoder.encode(PasswordUtil.AESEncrypt(new Date().getTime() + "", PWD), "UTF-8");
				
				String to = webUser.getAccount();
				String mailSubject = "账号激活";
				String mailContent = "请点击<br>" +
						"<a href='" + 
						url + 
						"' target='_blank'>" +
						url +
						"</a><br>以完成注册!";
				BaseData.mail.send(to, mailSubject, mailContent);
			}
		}catch (Exception e) {
			logger.error("发送验证邮件出错", e);
		}
		
	}
	
	/**
	 * 账号激活邮件检验处理
	 * @return
	 */
	public String web_mailConfirmHandle_forRegistered(){
		String a1 = request.getParameter("a1");
		String a2 = request.getParameter("a2");
		String a3 = request.getParameter("a3");
		
		try{
			if(null == a1 || null == a2 || null ==a3){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "非法链接!!");
				return WEB_MAIL_CONFIRM;
			}
			
			String time = PasswordUtil.AESDecrypt(a3, PWD);
			Date now = new Date();
			if(now.getTime() - Long.valueOf(time) > 24*3600*1000){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "此邮件激活地址已失效!!");
				return WEB_MAIL_CONFIRM;
			}
			
			String account = PasswordUtil.AESDecrypt(a2, PWD);
			if(!a1.equals(PasswordUtil.MD5(account))){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "非法链接!!");
				return WEB_MAIL_CONFIRM;
			}
			
			WebUserDao webUserDao = new WebUserDao();
			WebUser webUser = webUserDao.getWebUser(account);
			if(null == webUser){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "此用户不存在!!");
				return WEB_MAIL_CONFIRM;
			}else if(webUser.getState() != WebUser.STATE_UNACTIVE){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "请不要重复激活!!");
				return WEB_MAIL_CONFIRM;
			}
			
			webUser.setState(WebUser.STATE_NORMAL);
			webUserDao.update(webUser);
			setAttribute("confirmResult", "success");
			
			// 校验成功,后续处理
			LoginSessionService.userActiveOkHandle(request, webUser);
		}catch (Exception e) {
			setAttribute("confirmResult", "fail");
			setAttribute("confirmMsg", "非法链接!!");
			logger.error("邮件校验出错", e);
		}
		
		return WEB_MAIL_CONFIRM;
	}
	
	/**
	 * 找回密码
	 * @return
	 */
	public String findPwd(){
		setAttribute("authCodeName", AuthCodeNames[1]);
		return WEB_FINDPWD;
	}
	
	/**
	 * 找回密码处理
	 * @return
	 */
	public String web_findPwd_handle(){
		try{
			String account = request.getParameter("account");
			String authCode = request.getParameter("authCode");
			if(null == account || ValidationUtil.isSQLInjection(account)){
				setAttribute("errMsg", "账号非法");
				return findPwd();
			}
			setAttribute("account", account);
			
			String authCodeName = AuthCodeNames[1];
			if(null == request.getSession().getAttribute(authCodeName) || 
					!authCode.toLowerCase().equals(request.getSession().getAttribute(authCodeName).toString().toLowerCase())){
				setAttribute("errMsg", "验证码错误");
				return findPwd();
			}
			
			WebUser webUser = new WebUserDao().getWebUser(account);
			
			if(null == webUser){
				setAttribute("errMsg", "此账号不存在");
				return findPwd();
			}
			
			//发送邮件
			web_sendMailConfirm_forChangePwd(webUser);
			setAttribute("confirmResult", "success");
			setAttribute("confirmMsg", "邮件已经发送成功,请前往邮箱查看!!");
			return WEB_MAIL_CONFIRM;
		}catch (Exception e) {
			logger.error("找回密码处理出错", e);
			setAttribute("errMsg", "服务器出错");
		}
		
		return findPwd();
	}
	
	/**
	 * 修改密码
	 * @return
	 */
	public String web_changePwd_handle(){
		try{
			String account = (String)request.getSession().getAttribute("validation_nowChangeAccount");
			
			if(null == account){
				setAttribute("errMsg", "修改密码失败,此页面已失效");
				return WEB_CHANGEPWD;
			}
			
			String password = request.getParameter("password");
			if(ValidationUtil.isSQLInjection(password)){
				setAttribute("errMsg", "密码只能为数字和大小写字母");
				return WEB_CHANGEPWD;
			}
			
			if(password.length() < 6 || password.length() > 12){
				setAttribute("errMsg", "密码长度应在6~12位之间");
				return WEB_CHANGEPWD;
			}
			
			WebUserDao webUserDao = new WebUserDao();
			WebUser webUser = webUserDao.getWebUser(account);
			if(null == webUser){
				setAttribute("errMsg", "修改密码失败,此页面已失效");
				return WEB_CHANGEPWD;
			}else{
				webUser.setPassword(PasswordUtil.MD5(password));
				webUserDao.update(webUser);
				WebUserInfo webUserInfo = new WebUserInfoDao().getByUid(webUser.getId());
				webUserInfo.setLastLoginIp(getIpAddr());
				webUserInfo.setLastLoginTime(new Date());
				new WebUserInfoDao().update(webUserInfo);
				
				LoginSessionService.changePwdOkHandle(request, webUser, webUserInfo);
				request.getSession().setAttribute("validation_nowChangeAccount", null);
				return WEB_LOGIN_OK;
			}
		}catch (Exception e) {
			logger.error("修改密码出错", e);
			setAttribute("errMsg", "修改密码失败,服务器出错");
		}
		
		return WEB_CHANGEPWD;
	}
	
	/**
	 * 发送邮件检验(修改密码)
	 */
	private boolean web_sendMailConfirm_forChangePwd(WebUser webUser){
		try{
			String url = getRootHostUrl() + "/validation/web_mailConfirmHandle_forChangePwd.do";
			url += "?a1=" + URLEncoder.encode(PasswordUtil.MD5(webUser.getAccount()), "UTF-8");
			url += "&a2=" + URLEncoder.encode(PasswordUtil.AESEncrypt(webUser.getAccount(), PWD), "UTF-8");
			url += "&a3=" + URLEncoder.encode(PasswordUtil.AESEncrypt(new Date().getTime() + "", PWD), "UTF-8");
			
			String to = webUser.getAccount();
			String mailSubject = "更新密码";
			String mailContent = "请点击<br>" +
					"<a href='" + 
					url + 
					"' target='_blank'>" +
					url +
					"</a><br>以完成密码修改!";
			BaseData.mail.send(to, mailSubject, mailContent);
			return true;
		}catch (Exception e) {
			logger.error("发送验证邮件出错", e);
			setAttribute("errMsg", "服务器出错!");
		}
		
		return false;
	}
	
	/**
	 * 修改密码邮件检验处理
	 * @return
	 */
	public String web_mailConfirmHandle_forChangePwd(){
		String a1 = request.getParameter("a1");
		String a2 = request.getParameter("a2");
		String a3 = request.getParameter("a3");
		
		try{
			if(null == a1 || null == a2 || null ==a3){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "校验失败: 非法链接!!");
				return WEB_MAIL_CONFIRM;
			}
			
			String time = PasswordUtil.AESDecrypt(a3, PWD);
			Date now = new Date();
			if(now.getTime() - Long.valueOf(time) > 10 * 60 * 1000){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "校验失败: 此邮件校验地址已失效!!");
				return WEB_MAIL_CONFIRM;
			}
			
			String account = PasswordUtil.AESDecrypt(a2, PWD);
			if(!a1.equals(PasswordUtil.MD5(account))){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "校验失败: 非法链接!!");
				return WEB_MAIL_CONFIRM;
			}
			
			WebUserDao webUserDao = new WebUserDao();
			WebUser webUser =webUserDao.getWebUser(account);
			if(null == webUser){
				setAttribute("confirmResult", "fail");
				setAttribute("confirmMsg", "校验失败: 此用户不存在!!");
				return WEB_MAIL_CONFIRM;
			}
			
			setAttribute("confirmResult", "success");
			request.getSession().setAttribute("validation_nowChangeAccount", webUser.getAccount());
			
			return WEB_CHANGEPWD;
		}catch (Exception e) {
			setAttribute("confirmResult", "fail");
			setAttribute("confirmMsg", "校验失败: 非法链接!!");
			logger.error("邮件校验出错", e);
		}
		
		return WEB_MAIL_CONFIRM;
	}
	
	/**
	 * 获取验证码
	 */
	public void web_getAuthCode(){
		try{
			String authCodeName = request.getParameter("authCodeName");
			Map<String, Object> authCodeMap = ImageUtil.createImgAuthCode();
			if(null != authCodeName){
				request.getSession().setAttribute(authCodeName, authCodeMap.get("authCode"));
			}
			flushImgData((InputStream)authCodeMap.get("authImage"));
		}catch (Exception e) {
			logger.error("生成验证码失败.", e);
		}
	}
}
