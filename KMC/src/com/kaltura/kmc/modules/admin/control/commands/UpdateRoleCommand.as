package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.userRole.UserRoleUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.RoleEvent;
	import com.borhan.bmc.modules.admin.model.DrilldownMode;
	import com.borhan.vo.BorhanUserRole;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	/**
	 * update a role after editing it. 
	 * @author Atar
	 * 
	 */	
	public class UpdateRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var role:BorhanUserRole = (event as RoleEvent).role;
			role.setUpdatedFieldsOnly(true);
			var uu:UserRoleUpdate = new UserRoleUpdate(role.id, role);
			uu.addEventListener(BorhanEvent.COMPLETE, result);
			uu.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.kc.post(uu);
		}
		
		
		override protected function result(data:Object):void {
			super.result(data);
			if (data.success) {
				// no need to explicitly call list roles, as 
				// data is refreshed when the window closes. 
				_model.rolesModel.drilldownMode = DrilldownMode.NONE;
			}
			_model.decreaseLoadCounter();
			Alert.show(ResourceManager.getInstance().getString('admin', 'after_role_edit'));
		}
	}
}