package com.borhan.bmc.modules.account.control.command {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.user.UserList;
	import com.borhan.commands.userRole.UserRoleList;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.business.JSGate;
	import com.borhan.bmc.modules.account.model.AccountModelLocator;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.types.BorhanUserRoleStatus;
	import com.borhan.types.BorhanUserStatus;
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserFilter;
	import com.borhan.vo.BorhanUserListResponse;
	import com.borhan.vo.BorhanUserRoleFilter;
	import com.borhan.vo.BorhanUserRoleListResponse;
	
	import flash.display.Graphics;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexSprite;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	import mx.states.AddChild;

	public class ListUsersCommand implements ICommand {
		
		private var _model:AccountModelLocator = AccountModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// roles
			var rfilter:BorhanUserRoleFilter = new BorhanUserRoleFilter();
			rfilter.tagsMultiLikeOr = 'partner_admin';
			rfilter.statusEqual = BorhanUserRoleStatus.ACTIVE;
			var rl:UserRoleList = new UserRoleList(rfilter);
			mr.addAction(rl);
			// users
			var ufilter:BorhanUserFilter = new BorhanUserFilter();
			ufilter.isAdminEqual = BorhanNullableBoolean.TRUE_VALUE;
			ufilter.loginEnabledEqual = BorhanNullableBoolean.TRUE_VALUE;
			ufilter.statusEqual = BorhanUserStatus.ACTIVE;
			ufilter.roleIdsEqual = '0';
			var ul:UserList = new UserList(ufilter);
			mr.addAction(ul);
			mr.mapMultiRequestParam(1, 'objects:0:id', 2, 'filter:roleIdsEqual');
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			mr.queued = false;	// so numbering won't get messed up
			_model.context.kc.post(mr);
		}


		private function result(event:BorhanEvent):void {
			// error handling
			if(event && event.error && event.error.errorMsg && event.error.errorCode == APIErrorCode.INVALID_KS){
				JSGate.expired();
				return;
			}
			
			if (event.data && event.data.length > 0) {
				var l:int = event.data.length ;
				for(var i:int = 0; i<l; i++) {
					if (event.data[i].error && event.data[i].error.code) {
						Alert.show(event.data[i].error.message, ResourceManager.getInstance().getString('account', 'error'));
						return;
					}
				}
			}
			_model.usersList = new ArrayCollection((event.data[1] as BorhanUserListResponse).objects);
		}


		private function fault(event:BorhanEvent):void {
			if (event.error) {
				Alert.show(event.error.errorMsg, ResourceManager.getInstance().getString('account', 'error'));
			}
		}
	}
}