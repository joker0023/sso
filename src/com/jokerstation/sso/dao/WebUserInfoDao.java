package com.jokerstation.sso.dao;

import java.sql.SQLException;

import com.jokerstation.base.dao.BaseDao;
import com.jokerstation.sso.vo.WebUserInfo;

/**
 * WebUserInfo 的 dao
 * @author Joker
 *
 */
public class WebUserInfoDao extends BaseDao<WebUserInfo>{

	public WebUserInfoDao(){
		super(WebUserInfo.class);
	}
	
	public WebUserInfo getByUid(Long uid) throws SQLException{
		WebUserInfo entity = new WebUserInfo();
		entity.setUid(uid);
		return this.get(entity);
	}
}
