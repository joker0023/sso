package com.jokerstation.sso.redis;

import org.apache.log4j.Logger;

import com.jokerstation.base.util.RedisUtil;
import com.jokerstation.base.util.SerializeUtil;
import com.jokerstation.sso.vo.WebUser;
import com.jokerstation.sso.vo.WebUserInfo;

import redis.clients.jedis.Jedis;

/**
 * redis的相关操作方法
 * @author Joker
 *
 */
public class RedisApi {
	
	private static final Logger logger = Logger.getLogger(RedisApi.class);

	//session过期时间(单位秒)
	private static final int TIME_OUT = 10 * 60;
	
	//记录登录相关信息
	private static final int LOGIN = 15;
	
	
	private static final String WEBUSER = "web_user";
	private static final String WEBUSERINFO = "web_userinfo";
	
	/**
	 * 记录登录信息,当成session记录
	 * @param key
	 * @param webUser
	 * @param webUserInfo
	 * @return
	 */
	public static Long setLoginUser(String key, WebUser webUser, WebUserInfo webUserInfo){
		Jedis jedis = null;
		try {
			jedis = RedisUtil.getResource();
			jedis.select(LOGIN);
			if(null != webUser){
				byte[] value = SerializeUtil.serialize(webUser);
				jedis.hset(key.getBytes(), WEBUSER.getBytes(), value);
			}
			if(null != webUserInfo){
				byte[] value = SerializeUtil.serialize(webUserInfo);
				jedis.hset(key.getBytes(), WEBUSERINFO.getBytes(), value);
			}
		} catch (Exception e) {
			logger.error("",e);
		} finally {
            RedisUtil.returnResource(jedis);
        }
		return 0L;
	}
	
	/**
	 * 获得登录session的webuser
	 * @param key
	 * @return
	 */
	public static WebUser getWebUser(String key) {
		Jedis jedis = null;
		try {
			jedis = RedisUtil.getResource();
			jedis.select(LOGIN);
			byte[] value = jedis.hget(key.getBytes(), WEBUSER.getBytes());
			if(null != value){
				Object obj = SerializeUtil.unserialize(value);
				return (WebUser)obj;
			}
		}catch (Exception e) {
			logger.error("",e);
		} finally {
            RedisUtil.returnResource(jedis);
        }
		return null;
	}
	
	/**
	 * 获取登录session的webuserinfo
	 * @param key
	 * @return
	 */
	public static WebUserInfo getWebUserInfo(String key) {
		Jedis jedis = null;
		try {
			jedis = RedisUtil.getResource();
			jedis.select(LOGIN);
			byte[] value = jedis.hget(key.getBytes(), WEBUSERINFO.getBytes());
			if(null != value){
				Object obj = SerializeUtil.unserialize(value);
				return (WebUserInfo)obj;
			}
		}catch (Exception e) {
			logger.error("",e);
		} finally {
            RedisUtil.returnResource(jedis);
        }
		return null;
	}
	
	/**
	 * 设置登录session过期时间
	 * @param account
	 */
	public static void setLoginExpire(String key) {
		expireKey(LOGIN, key, TIME_OUT);
	}
	
	
	/*
	 * ********************************
	 * 
	 *	基本方法 
	 *
	 * ********************************
	 */
	
	
	/**
	 * 设置redis某个库的某个key的过期时间
	 * @param index
	 * @param key
	 * @param time
	 */
	public static void expireKey(int index,String key, int time){
		Jedis jedis = null;
        try {
            jedis = RedisUtil.getResource();
            jedis.select(index);
            jedis.expire(key, time);
        } catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
            RedisUtil.returnResource(jedis);
        }
	}
}
