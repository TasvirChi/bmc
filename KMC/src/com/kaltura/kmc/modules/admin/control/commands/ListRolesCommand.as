package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.userRole.UserRoleList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.ListItemsEvent;
	import com.borhan.vo.BorhanUserRoleFilter;
	import com.borhan.vo.BorhanUserRoleListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListRolesCommand extends BaseCommand {
		
		/**
		 * @inheritDocs
		 */
		override public function execute(event:CairngormEvent):void {
			var e:ListItemsEvent = event as ListItemsEvent;
			var ul:UserRoleList = new UserRoleList(e.filter as BorhanUserRoleFilter, e.pager);
			ul.addEventListener(BorhanEvent.COMPLETE, result);
			ul.addEventListener(BorhanEvent.FAILED, fault);
			if (_model.kc) {
				_model.increaseLoadCounter();
				_model.kc.post(ul);
			}
		}
		
		
		/**
		 * set received data on model
		 * @param data data returned from server.
		 */
		override protected function result(data:Object):void {
			super.result(data);
			var response:BorhanUserRoleListResponse = data.data as BorhanUserRoleListResponse;
			_model.rolesModel.roles = new ArrayCollection(response.objects);
			_model.rolesModel.totalRoles = response.totalCount;
			_model.decreaseLoadCounter();
		}
		
	}
}