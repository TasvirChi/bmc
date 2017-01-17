package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.borhan.bmc.modules.content.events.SetSyndicationPagerEvent;
	
	public class setSyndicationFeedsFilterPager extends BorhanCommand implements ICommand {
		
		
		override public function execute(event:CairngormEvent):void
		{
			_model.extSynModel.syndicationFeedsFilterPager = (event as SetSyndicationPagerEvent).pager;
		}
	}
}