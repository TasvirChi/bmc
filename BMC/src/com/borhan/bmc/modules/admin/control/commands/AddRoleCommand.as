package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.userRole.UserRoleAdd;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.RoleEvent;
	import com.borhan.bmc.modules.admin.model.DrilldownMode;

	public class AddRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var ua:UserRoleAdd = new UserRoleAdd((event as RoleEvent).role);
			ua.addEventListener(BorhanEvent.COMPLETE, result);
			ua.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.kc.post(ua);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				_model.rolesModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
		}
	}
}