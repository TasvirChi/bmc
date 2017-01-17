package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.user.UserDelete;
	import com.borhan.commands.user.UserList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.UserEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanUserListResponse;
	
	import mx.collections.ArrayCollection;

	public class DeleteUserCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// delete
			var call:BorhanCall = new UserDelete((event as UserEvent).user.id);
			mr.addAction(call);
			// list
			call = new UserList(_model.usersModel.usersFilter);
			mr.addAction(call);
			// post
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.kc.post(mr);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			var response:BorhanUserListResponse = data.data[1] as BorhanUserListResponse;
			_model.usersModel.users = new ArrayCollection(response.objects);
			// users quota
			_model.usersModel.totalUsers = response.totalCount;
			_model.decreaseLoadCounter();
		}
	}
}