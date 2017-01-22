package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.userRole.UserRoleAdd;
	import com.borhan.commands.userRole.UserRoleList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.RoleEvent;
	import com.borhan.bmc.modules.admin.model.DrilldownMode;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanUserRole;
	
	import mx.collections.ArrayCollection;

	public class AddRoleFromUserCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			var call:BorhanCall = new UserRoleAdd((event as RoleEvent).role);
			mr.addAction(call);
			call = new UserRoleList(_model.rolesModel.rolesFilter);
			mr.addAction(call);
			_model.increaseLoadCounter();
			_model.kc.post(mr);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				// change the flag to close the role drilldown
				// update the roles combobox dataprovider 
				_model.rolesModel.roles = new ArrayCollection(data.data[1].objects);
				// trigger the setter to use the returned object as the role for current user
				_model.usersModel.newRole = data.data[0] as BorhanUserRole;
				// just to trigger the closing:
				_model.usersModel.roleDrilldownMode = DrilldownMode.ADD;
				_model.usersModel.roleDrilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
		}
	}
}