package com.borhan.bmc.modules.admin.control.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.analytics.GoogleAnalyticsConsts;
	import com.borhan.analytics.GoogleAnalyticsTracker;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.user.UserList;
	import com.borhan.commands.user.UserUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.admin.control.events.UserEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.types.BorhanUserStatus;
	import com.borhan.vo.BorhanUser;
	import com.borhan.vo.BorhanUserListResponse;
	
	import mx.collections.ArrayCollection;

	public class ToggleUserStatusCommand extends BaseCommand {
		
		override public function execute(event:CairngormEvent):void {
			var mr:MultiRequest = new MultiRequest();
			// toggle
			var gaEvent:String;
			var usr:BorhanUser = (event as UserEvent).user;
			usr.setUpdatedFieldsOnly(true);
			if (usr.status == BorhanUserStatus.ACTIVE) {
				usr.status = BorhanUserStatus.BLOCKED;
				gaEvent = GoogleAnalyticsConsts.ADMIN_USER_BLOCK;
			}
			else if(usr.status == BorhanUserStatus.BLOCKED) {
				usr.status = BorhanUserStatus.ACTIVE;
				gaEvent = GoogleAnalyticsConsts.ADMIN_USER_UNBLOCK;
			}
			var call:BorhanCall = new UserUpdate(usr.id, usr);
			mr.addAction(call);
			// list
			call = new UserList(_model.usersModel.usersFilter);
			mr.addAction(call);
			// post
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.kc.post(mr);
			GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.PAGE_VIEW + gaEvent);
		}
		
		override protected function result(data:Object):void {
			super.result(data);
			var response:BorhanUserListResponse = data.data[1] as BorhanUserListResponse;
			_model.usersModel.users = new ArrayCollection(response.objects);
			_model.decreaseLoadCounter();
		}
	}
}