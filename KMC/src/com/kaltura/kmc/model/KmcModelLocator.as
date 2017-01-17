package com.borhan.bmc.model {
	import com.adobe.cairngorm.model.IModelLocator;
	import com.borhan.BorhanClient;
	import com.borhan.edw.business.permissions.PermissionManager;
	import com.borhan.bmc.vo.UserVO;
	import com.borhan.types.BorhanPermissionStatus;
	import com.borhan.types.BorhanPermissionType;
	import com.borhan.vo.BorhanPermission;
	import com.borhan.vo.BorhanPermissionFilter;

	import flash.events.EventDispatcher;

	[Bindable]
	public class BmcModelLocator extends EventDispatcher implements IModelLocator {

		///////////////////////////////////////////
		//singleton methods
		/**
		 * singleton instance
		 */
		private static var _instance:BmcModelLocator;


		/**
		 * Borhan Client. This should be the instance that every module will get and use
		 */
		public var borhanClient:BorhanClient;

		/**
		 * The instance of a PermissionManager.
		 */
		public var permissionManager:PermissionManager;

		/**
		 * Flashvars of the main app wrapped in one object. The items are
		 */
		public var flashvars:Object;

		public var userInfo:UserVO;

		public var permissionsListFilter:BorhanPermissionFilter;


		/**
		 * singleton means of retreiving an instance of the
		 * <code>BmcModelLocator</code> class.
		 */
		public static function getInstance():BmcModelLocator {
			if (_instance == null) {
				_instance = new BmcModelLocator(new Enforcer());

			}
			return _instance;
		}


		/**
		 * initialize parameters and sub-models.
		 * @param enforcer	singleton garantee
		 */
		public function BmcModelLocator(enforcer:Enforcer) {
			permissionManager = PermissionManager.getInstance();

			permissionsListFilter = new BorhanPermissionFilter();
			permissionsListFilter.typeIn = BorhanPermissionType.SPECIAL_FEATURE + ',' + BorhanPermissionType.PLUGIN;
			permissionsListFilter.statusEqual = BorhanPermissionStatus.ACTIVE;
		}


	}
}

class Enforcer {

}