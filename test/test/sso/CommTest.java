package test.sso;

import com.jokerstation.sso.redis.RedisApi;
import com.jokerstation.sso.vo.WebUser;

public class CommTest {

	public static void main(String[] args) {
		try{
			WebUser user = null;
			Object obj = (Object)user;
			user = (WebUser)obj;
			
			if(null == user){
				System.out.println("is null");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
}
