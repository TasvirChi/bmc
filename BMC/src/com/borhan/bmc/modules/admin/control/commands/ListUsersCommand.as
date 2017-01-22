package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.user.UserList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.ListItemsEvent;
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserFilter;
	import com.borhan.vo.BorhanUserListResponse;
	
	import mx.collections.ArrayCollection;

	public class ListUsersCommand extends BaseCommand {
		
		/**
		 * @inheritDocs
		 */
		override public function execute(event:CairngormEvent):void {
			var e:ListItemsEvent = event as ListItemsEvent;
			var ul:UserList = new UserList(e.filter as BorhanUserFilter, e.pager);
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
			var response:BorhanUserListResponse = data.data as BorhanUserListResponse;
			var resultArray:ArrayCollection = new ArrayCollection(response.objects);
			setOwnerFirstInArray(resultArray);
			_model.usersModel.users = resultArray;
			_model.usersModel.totalUsers = response.totalCount;
			_model.decreaseLoadCounter();
		}
		
		/**
		 * sets the owner user to be the first user
		 * */
		private function setOwnerFirstInArray(arr:ArrayCollection):void {
			for (var i:int = 0; i<arr.length; i++){
				var user:BorhanUser = arr.getItemAt(i) as BorhanUser;
				if (user.isAccountOwner) {
					arr.removeItemAt(i);
					arr.addItemAt(user,0);
					return;
				}
			}
			
		}
	}
}