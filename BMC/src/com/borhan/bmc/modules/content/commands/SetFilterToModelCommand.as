package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.events.BMCFilterEvent;

	public class SetFilterToModelCommand extends BorhanCommand implements ICommand
	{
		override public function execute(event:CairngormEvent):void
		{
			
			_model.playlistModel.onTheFlyFilter = (event as BMCFilterEvent).filterVo;
		}
	}
}