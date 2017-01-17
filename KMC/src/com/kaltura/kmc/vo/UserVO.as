package com.borhan.bmc.vo
{
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserRole;

	[Bindable]
	/**
	 * holds together data about a user and their role 
	 * @author Atar
	 */	
	public class UserVO {
		
		/**
		 * user details 
		 */
		public var user:BorhanUser;
		
		/**
		 * the role associated with <code>user</code> 
		 */		
		public var role:BorhanUserRole;
	}
}