package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.user.UserAdd;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.ListItemsEvent;
	import com.borhan.bmc.modules.admin.control.events.UserEvent;
	import com.borhan.bmc.modules.admin.model.DrilldownMode;
	import com.borhan.vo.BorhanUser;
	import com.borhan.commands.user.UserGet;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.events.CloseEvent;
	import com.borhan.commands.user.UserEnableLogin;

	public class AddUserCommand extends BaseCommand {
		
		private var _user:BorhanUser;
		/**
		 * the email with which we will create the logindata for the user 
		 */
		private var _requiredLoginEmail:String; 
		
		override public function execute(event:CairngormEvent):void {
			// save user for future use
			_user = (event as UserEvent).user;
			// check if the user is listed as end user in the current account (KMS user etc)
			var ua:UserGet = new UserGet((event as UserEvent).user.id);
			ua.addEventListener(BorhanEvent.COMPLETE, getUserResult);
			ua.addEventListener(BorhanEvent.FAILED, getUserFault);
			_model.increaseLoadCounter();
			_model.kc.post(ua);
		}
		
		
		/**
		 * user is not yet listed in the current account, should add. 
		 * */
		private function getUserFault(data:BorhanEvent):void {
			if (data.error.errorCode == "INVALID_USER_ID") {
				addUser();
			}
		}
		
		
		/**
		 * user is already listed in the current account as end user, should update.
		 * */ 
		private function getUserResult(data:BorhanEvent):void {
			var role:String = _user.roleIds;
			_requiredLoginEmail = _user.email; // the email entered on screen
			
			_user = data.data as BorhanUser;
			_user.roleIds = role;
			var str:String = ResourceManager.getInstance().getString('admin', 'user_exists_current_partner', [_user.id]);
			Alert.show(str, ResourceManager.getInstance().getString('admin', 'add_user_title'), Alert.YES|Alert.NO, null, closeHandler);
		}
		
		
		protected function closeHandler(e:CloseEvent):void {
			switch (e.detail) {
				case Alert.YES:
					updateUser();
					break;
				case Alert.NO:
					// do nothing
					break;
			}
			_model.decreaseLoadCounter();
		}
		
		
		/**
		 * update permissions on existing user
		 * */
		private function updateUser():void {
			_user.isAdmin = true;
			var ue:UserEvent = new UserEvent(UserEvent.UPDATE_USER, _user);
			ue.dispatch();
			
			// enable user login
			var ua:UserEnableLogin = new UserEnableLogin(_user.id, _requiredLoginEmail, _user.password);
			ua.addEventListener(BorhanEvent.COMPLETE, enableLoginResult);
			ua.addEventListener(BorhanEvent.FAILED, fault);
			_model.kc.post(ua);
		}
		
		
		private function enableLoginResult(event:BorhanEvent):void {
			// do nothing.
		}
		
		private function addUser():void {
			var ua:UserAdd = new UserAdd(_user);
			ua.addEventListener(BorhanEvent.COMPLETE, addUserResult);
			ua.addEventListener(BorhanEvent.FAILED, fault);
			_model.kc.post(ua);
		}
		
		private function addUserResult(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.usersModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
		}
	}
}