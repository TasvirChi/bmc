package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.user.UserNotifyBan;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.UserEvent;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	public class BanUserCommand extends BorhanCommand implements ICommand, IResponder
	{

		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var e : UserEvent = event as UserEvent;
			var useerBanNotify:UserNotifyBan = new UserNotifyBan(e.userVo.puserId)
			useerBanNotify.addEventListener(BorhanEvent.COMPLETE, result);
			useerBanNotify.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(useerBanNotify);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			Alert.show( ResourceManager.getInstance().getString('cms','userBanned') );
		}
	}
}