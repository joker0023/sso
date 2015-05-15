package com.jokerstation.sso.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.jokerstation.sso.redis.RedisApi;
import com.jokerstation.sso.vo.WebUser;
import com.jokerstation.sso.vo.WebUserInfo;

/**
 * 登录模块session记录服务
 * @author Joker
 *
 */
public class LoginSessionService {

	private static final String WEBUSER = "web_user";
	private static final String WEBUSERINFO = "web_userinfo";
	
	
	/**
	 * 登录成功后的处理
	 * @param request
	 * @param webUser
	 * @param webUserInfo
	 */
	public static void loginOkHandle(HttpServletRequest request, WebUser webUser, WebUserInfo webUserInfo) {
		request.getSession().setAttribute(WEBUSER, webUser);
		request.getSession().setAttribute(WEBUSERINFO, webUserInfo);
	}
	
	/**
	 * 退出成功后的处理
	 * @param request
	 */
	public static void logoutOkHandle(HttpServletRequest request) {
		request.getSession().setAttribute(WEBUSER, null);
		request.getSession().setAttribute(WEBUSERINFO, null);
	}
	
	/**
	 * 注册成功后的处理
	 * @param request
	 * @param webUser
	 * @param webUserInfo
	 */
	public static void registeredOkHandle(HttpServletRequest request, WebUser webUser, WebUserInfo webUserInfo) {
		loginOkHandle(request, webUser, webUserInfo);
	}
	
	/**
	 * 账号激活成功后续处理
	 */
	public static void userActiveOkHandle(HttpServletRequest request, WebUser webUser) {
		request.getSession().setAttribute(WEBUSER, webUser);
	}
	
	/**
	 * 修改密码成功后续处理
	 * @param request
	 * @param webUser
	 * @param webUserInfo
	 */
	public static void changePwdOkHandle(HttpServletRequest request, WebUser webUser, WebUserInfo webUserInfo) {
		request.getSession().setAttribute("webUser", webUser);
		request.getSession().setAttribute("webUserInfo", webUserInfo);
	}
	
	
	
	
	
	/**
	 * 获取登录的webuser
	 * @param key
	 * @param session
	 * @return
	 * @throws Exception
	 */
	public static WebUser getWebUser(String key, HttpSession session) throws Exception {
		WebUser webUser = (WebUser)session.getAttribute(WEBUSER);
		if(null != webUser){
			return webUser;
		}
		
		return RedisApi.getWebUser(key);
	}
	
	/**
	 * 获取登录的webuserinfo
	 * @param key
	 * @param session
	 * @return
	 * @throws Exception
	 */
	public static WebUserInfo getWebUserInfo(String key, HttpSession session) throws Exception {
		WebUserInfo webUserInfo = (WebUserInfo)session.getAttribute(WEBUSERINFO);
		if(null != webUserInfo){
			return webUserInfo;
		}
		
		return RedisApi.getWebUserInfo(key);
	}
}
