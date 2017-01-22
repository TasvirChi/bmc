package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.userRole.UserRoleClone;
	import com.borhan.commands.userRole.UserRoleList;
	import com.borhan.commands.userRole.UserRoleUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.RoleEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.utils.ObjectUtil;
	import com.borhan.vo.BorhanUserRole;
	import com.borhan.vo.BorhanUserRoleListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class DuplicateRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			var call:BorhanCall;
			var role:BorhanUserRole = (event as RoleEvent).role; 
			// pass result of first call to second call
//			mr.addRequestParam("2:userRoleId", "{1:result:id}");
			mr.mapMultiRequestParam(1, "id", 2, "userRoleId");
			mr.addRequestParam("2:userRole:name", ResourceManager.getInstance().getString('admin', 'duplicate_name', [role.name]));
			// duplicate the role
			call = new UserRoleClone(role.id);
			mr.addAction(call);
			// edit new role's name (both params are dummy, real value is taken from the first call
			call = new UserRoleUpdate(5, new BorhanUserRole());
			mr.addAction(call);
			
			// list
			call = new UserRoleList(_model.rolesModel.rolesFilter);
			mr.addAction(call);
			// post
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			mr.queued = false;
			_model.increaseLoadCounter();
			_model.kc.post(mr);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			// select the new role
			_model.rolesModel.selectedRole = data.data[1] as BorhanUserRole;
			// open drilldown for returned BorhanRole
			_model.rolesModel.newRole = data.data[1] as BorhanUserRole;
			_model.rolesModel.newRole = null;
			
			var response:BorhanUserRoleListResponse = data.data[2] as BorhanUserRoleListResponse;
			_model.rolesModel.roles = new ArrayCollection(response.objects);
			_model.decreaseLoadCounter();
		} 
	}
}