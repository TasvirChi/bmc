package com.borhan.edw.control.commands.usrs
{
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.user.UserGet;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.UsersEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class GetEntitledUsersCommand extends KedCommand {
		
		private var _type:String;
		
		override public function execute(event:BMvCEvent):void {
			_type = event.type;
			_model.increaseLoadCounter();
			
			var mr:MultiRequest = new MultiRequest();
			var ids:Array = event.data.split(",");
			var getUser:UserGet 
			
			for (var i:int = 0; i<ids.length; i++) {
				getUser = new UserGet(ids[i]);
				mr.addAction(getUser);
					
			}
			
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(mr);
		}
		
		
		override public function result(data:Object):void {
			super.result(data);
			if (data.data && data.data is Array) {
				var isError:Boolean = checkErrors(data);
				if (!isError) {
					var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
					switch (_type) {
						case UsersEvent.GET_ENTRY_EDITORS:
							edp.entryEditors = data.data as Array;
							break;
						
						case UsersEvent.GET_ENTRY_PUBLISHERS:
							edp.entryPublishers = data.data as Array;
							break;
					}
				}
			}
			_model.decreaseLoadCounter();
		}
	}
}