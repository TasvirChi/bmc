package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.permission.PermissionList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanPermission;
	import com.borhan.vo.BorhanPermissionListResponse;
	
	public class ListPartnerPermissionsCommand extends BaseCommand {
		
		/**
		 * @inheritDocs
		 */
		override public function execute(event:CairngormEvent):void {
			var largePager:BorhanFilterPager = new BorhanFilterPager();
			largePager.pageSize = 500;
			var ul:PermissionList = new PermissionList(_model.rolesModel.permissionsFilter, largePager);
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
			var response:BorhanPermissionListResponse = data.data as BorhanPermissionListResponse;
			_model.rolesModel.partnerPermissions = parsePartnerPermissions(response);
			_model.decreaseLoadCounter();
		}
		
		
		/**
		 * parse the permissions list response
		 * @param klr	the permissions list response
		 * @return a comma separated string of partner permission ids.
		 * */
		protected function parsePartnerPermissions(klr:BorhanPermissionListResponse):String {
			var result:String = '';
			for each (var kperm:BorhanPermission in klr.objects) {
				result += kperm.name + ",";
			}
			// remove last ","
			result = result.substring(0, result.length - 1);
			return result;
		}
	}
}