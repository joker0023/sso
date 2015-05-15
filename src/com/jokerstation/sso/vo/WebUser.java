package com.jokerstation.sso.vo;

import javax.persistence.Id;
import javax.persistence.Table;

import com.joker23.orm.persistence.POJO;

/**
 * 用户表对象,记录用户的登录账号密码等
 * @author Joker
 *
 */
@Table(name="web_user")
public class WebUser extends POJO{

	private static final long serialVersionUID = -8682396515034005196L;

	public static final int STATE_UNACTIVE = 0;	//未激活
	public static final int STATE_NORMAL = 1;	//正常状态
	public static final int STATE_DISABLE = 2;	//停用
	
	@Id
	private Long id;
	
	/**
	 * email
	 */
	private String account;
	
	/**
	 * 密码
	 */
	private String password;
	
	/**
	 * 状态
	 * 0 -- 未激活
	 * 1 -- 正常
	 * 2 -- 停用
	 */
	private Integer state;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}
	
}
