package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.userRole.UserRoleDelete;
	import com.borhan.commands.userRole.UserRoleList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.RoleEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanUserRoleListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class DeleteRoleCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// delete
			var call:BorhanCall = new UserRoleDelete((event as RoleEvent).role.id);
			mr.addAction(call);
			// list
			call = new UserRoleList(_model.rolesModel.rolesFilter);
			mr.addAction(call);
			
			// post
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.kc.post(mr);
		}
		
		override protected function result(data:Object):void {
			// note the optional response of "still have users associated with role"
			super.result(data);
			
			if (data.data[0].error && data.data[0].error.code == "ROLE_IS_BEING_USED") {
				var rm:IResourceManager = ResourceManager.getInstance(); 
				Alert.show(rm.getString('admin', 'role_in_use'), rm.getString('admin', 'error')) ;
			}
			
			var response:BorhanUserRoleListResponse = data.data[1] as BorhanUserRoleListResponse;
			_model.rolesModel.roles = new ArrayCollection(response.objects);
			_model.decreaseLoadCounter();
		}
	}
}