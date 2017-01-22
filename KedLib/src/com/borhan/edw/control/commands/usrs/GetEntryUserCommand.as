package com.borhan.edw.control.commands.usrs
{
	import com.borhan.commands.user.UserGet;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.UsersEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanUser;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	public class GetEntryUserCommand extends KedCommand {
		
		private var _type:String;
		private var _userId:String;
		
		override public function execute(event:BMvCEvent):void {
			
			if (event.type == UsersEvent.RESET_ENTRY_USERS) {
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				edp.selectedEntryCreator = null;
				edp.selectedEntryOwner = null;
				edp.entryEditors = null;
				edp.entryPublishers = null;
				return;
			}
			
			// otherwise, get the required user
			_type = event.type;
			_userId = event.data;
			
			_model.increaseLoadCounter();
			
			var getUser:UserGet = new UserGet(event.data);
			
			getUser.addEventListener(BorhanEvent.COMPLETE, result);
			getUser.addEventListener(BorhanEvent.FAILED, result);	// intentionally so
			
			_client.post(getUser);
		}
		
		
		
		override public function result(data:Object):void {
			super.result(data);
			
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			if (data.data && data.data is BorhanUser) {
				switch (_type) {
					case UsersEvent.GET_ENTRY_CREATOR:
						edp.selectedEntryCreator = data.data as BorhanUser;
						break;
					
					case UsersEvent.GET_ENTRY_OWNER:
						edp.selectedEntryOwner = data.data as BorhanUser;
						break;
				}
			}
			else if (data.error) {
				var er:BorhanError = data.error;
				if (er.errorCode == "INVALID_USER_ID") {
					// the user is probably deleted, create a dummy user:
					var usr:BorhanUser = new BorhanUser();
					usr.id = _userId;
					usr.screenName = _userId;
					switch (_type) {
						case UsersEvent.GET_ENTRY_CREATOR:
							edp.selectedEntryCreator = usr;
							break;
						
						case UsersEvent.GET_ENTRY_OWNER:
							edp.selectedEntryOwner = usr;
							break;
					}
				}
				else {
					Alert.show(getErrorText(er), ResourceManager.getInstance().getString('drilldown', 'error'));
				}
			}
			_model.decreaseLoadCounter();
		}
	}
}