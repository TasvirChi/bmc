package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class ChangeSyndicationFeedsFilterOrderCommand extends BorhanCommand implements ICommand {
		
		
		override public function execute(event:CairngormEvent):void
		{
			_model.extSynModel.syndicationFeedsFilter.orderBy = event.data;
		}
	}
}