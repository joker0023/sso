package com.jokerstation.sso.init;

import javax.servlet.ServletContextEvent;

import com.joker23.orm.connection.ConnectionFactory;
import com.jokerstation.base.data.BaseData;
import com.jokerstation.base.init.BaseInit;

/**
 * 初始化执行对象
 * 用于web服务器启动时执行
 * @author Joker
 *
 */
public class Init extends BaseInit{

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		try{
			super.contextInitialized(arg0);
			// 读取配置文件,获得默认值
			getDistProperties();
			
			//初始化数据库
			ConnectionFactory.init(BaseData.alias, BaseData.dbFileName);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 加载web配置文件
	 */
	private static void getDistProperties() {
		try{
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	

}
