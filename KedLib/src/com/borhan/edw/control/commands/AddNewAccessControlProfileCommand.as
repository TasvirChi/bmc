package com.borhan.edw.control.commands
{
	import com.borhan.commands.accessControl.AccessControlAdd;
	import com.borhan.edw.control.events.AccessControlEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.AccessControlProfileVO;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class AddNewAccessControlProfileCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void
		{
			_dispatcher = event.dispatcher;
			var accessControl:AccessControlProfileVO = event.data;
			var addNewAccessControl:AccessControlAdd = new AccessControlAdd(accessControl.profile);
		 	addNewAccessControl.addEventListener(BorhanEvent.COMPLETE, result);
			addNewAccessControl.addEventListener(BorhanEvent.FAILED, fault);
			var context:ContextDataPack = _model.getDataPack(ContextDataPack) as ContextDataPack;
			context.kc.post(addNewAccessControl);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			if(data.success)
			{
				Alert.show(ResourceManager.getInstance().getString('cms', 'addNewAccessControlDoneMsg'));
				var getAllProfilesEvent:AccessControlEvent = new AccessControlEvent(AccessControlEvent.LIST_ACCESS_CONTROLS_PROFILES);
				_dispatcher.dispatch(getAllProfilesEvent);
			}
			else
			{
				Alert.show(data.error, ResourceManager.getInstance().getString('cms', 'error'));
			}
		}
		
//		override public function fault(event:Object):void
//		{
//			_model.decreaseLoadCounter();
//			Alert.show(event.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
//		}
		

	}
}