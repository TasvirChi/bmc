package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.admin.control.events.RoleEvent;

	public class SelectRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			_model.rolesModel.selectedRole = (event as RoleEvent).role;
		} 
	}
}