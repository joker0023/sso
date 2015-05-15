package com.jokerstation.sso.dao;

import java.sql.SQLException;
import java.util.List;

import com.jokerstation.base.dao.BaseDao;
import com.jokerstation.sso.vo.WebUser;

/**
 * WebUser 的 dao
 * @author Joker
 *
 */
public class WebUserDao extends BaseDao<WebUser>{

	public WebUserDao() {
		super(WebUser.class);
	}
	
	public WebUser getWebUser(String account) throws SQLException{
		WebUser entity = new WebUser();
		entity.setAccount(account);
		return this.get(entity);
	}
	
	public long countByCustom(Integer state) throws SQLException{
		WebUser entity = new WebUser();
		if(null != state){
			entity.setState(state);
		}
		return this.count(entity);
	}
	
	public List<WebUser> listByCustom(Integer state, int page, int size) throws SQLException{
		WebUser entity = new WebUser();
		if(null != state){
			entity.setState(state);
		}
		return this.list(entity, page, size);
	}

}
