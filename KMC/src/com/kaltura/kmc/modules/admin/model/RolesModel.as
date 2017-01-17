package com.borhan.bmc.modules.admin.model
{
	import com.borhan.types.BorhanPermissionStatus;
	import com.borhan.types.BorhanPermissionType;
	import com.borhan.types.BorhanUserRoleOrderBy;
	import com.borhan.types.BorhanUserRoleStatus;
	import com.borhan.vo.BorhanPermissionFilter;
	import com.borhan.vo.BorhanUserRole;
	import com.borhan.vo.BorhanUserRoleFilter;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class RolesModel {
		
		public function RolesModel(){
			// get only active roles (not deleted)
			rolesFilter = new BorhanUserRoleFilter();
			rolesFilter.statusEqual = BorhanUserRoleStatus.ACTIVE;
			rolesFilter.orderBy = BorhanUserRoleOrderBy.ID_ASC;
			rolesFilter.tagsMultiLikeOr = 'bmc';
			// only get speacial, non-deleted features
			permissionsFilter = new BorhanPermissionFilter();
			permissionsFilter.typeIn = BorhanPermissionType.SPECIAL_FEATURE + ',' + BorhanPermissionType.PLUGIN;
			permissionsFilter.statusEqual = BorhanPermissionStatus.ACTIVE;
		}
		
		/**
		 * the active role entry.
		 * */
		public var selectedRole:BorhanUserRole;
		
		[ArrayElementType("BorhanUserRole")]
		/**
		 * list of all roles (BorhanRole objects) 
		 */
		public var roles:ArrayCollection;
		
		/**
		 * total number of rols as indicated by list result 
		 */		
		public var totalRoles:int;
		
		/**
		 * the filter used for listing roles. 
		 */		
		public var rolesFilter:BorhanUserRoleFilter;
		
		/**
		 * the filter used for listing partner permissions
		 * (only get speacial features). 
		 */		
		public var permissionsFilter:BorhanPermissionFilter;
		
		
		/**
		 * role drilldown mode, either <code>DrilldownMode.ADD</code>, 
		 * <code>DrilldownMode.EDIT</code> or  <code>DrilldownMode.NONE</code>.
		 * */
		public var drilldownMode:String = DrilldownMode.NONE;
		
		
		/**
		 * when duplications a role from the roles table, need to open a 
		 * drilldown window for it. since the only way to trigger ui actions
		 * is via binding, we'll use this propoerty.    
		 */		
		public var newRole:BorhanUserRole;
		
		
		/**
		 * all partner's permissions uiconf 
		 */
		public var partnerPermissionsUiconf:XML;
		
		/**
		 * a list of permissions ids from the BorhanPartner data (features, plugins)
		 */
		public var partnerPermissions:String;
	}
}