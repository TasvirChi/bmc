package com.borhan.bmc.modules.admin.model
{
	import com.borhan.bmc.vo.UserVO;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.types.BorhanUserOrderBy;
	import com.borhan.types.BorhanUserStatus;
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserFilter;
	import com.borhan.vo.BorhanUserRole;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class UsersModel {
		
		public function UsersModel() {
			// init filter - only admin users who have access to BMC and are either active or blocked.
			usersFilter = new BorhanUserFilter();
			usersFilter.isAdminEqual = BorhanNullableBoolean.TRUE_VALUE;
			usersFilter.loginEnabledEqual = BorhanNullableBoolean.TRUE_VALUE;
			usersFilter.statusIn = BorhanUserStatus.ACTIVE + "," + BorhanUserStatus.BLOCKED;
			usersFilter.orderBy = BorhanUserOrderBy.CREATED_AT_ASC;
		}
		
		/**
		 * info about the current (active) user 
		 */		
		public var currentUserInfo:UserVO;
		
		/**
		 * the active user entry.
		 * */
		public var selectedUser:BorhanUser;
		
		[ArrayElementType("BorhanUser")]
		/**
		 * a list of all users (BorhanUser objects)
		 * */
		public var users:ArrayCollection;
		
		/**
		 * total number of users as indicated by list result 
		 */		
		public var totalUsers:int;
		
		/**
		 * total number of users the partner may use 
		 */
		public var loginUsersQuota:int;
		
		/**
		 * the filter used for listing users. 
		 */		
		public var usersFilter:BorhanUserFilter;
		
		/**
		 * link to upgrade page on corp website
		 * */
		public var usersUpgradeLink:String;
		
		/**
		 * user drilldown mode, either <code>DrilldownMode.ADD</code>, 
		 * <code>DrilldownMode.EDIT</code> or <code>DrilldownMode.NONE</code>.
		 * */
		public var drilldownMode:String = DrilldownMode.NONE;
		
		/**
		 * role drilldown mode when opened from this screen, either <code>DrilldownMode.ADD</code>, 
		 * <code>DrilldownMode.EDIT</code> or <code>DrilldownMode.NONE</code>.
		 * */
		public var roleDrilldownMode:String = DrilldownMode.NONE;
		
		
		/**
		 * when creating a new role from the user drilldown, need to pass  
		 * the BorhanUserRole returned from the server back to the user drilldown   
		 * window via the model. 
		 */		
		public var newRole:BorhanUserRole;
		
		[ArrayElementType("String")]
		/**
		 * users that in users table don't have destructive actions 
		 * (user ids separated by ',') 
		 */		
		public var crippledUsers:Array;
		
		
		/**
		 * the partner's admin user id. 
		 */
		public var adminUserId:String;
		
		
	}
}