package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.media.MediaListFlags;
	import com.borhan.events.BorhanEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanModerationFlag;
	import com.borhan.vo.BorhanModerationFlagListResponse;
	
	import mx.rpc.IResponder;
	import com.borhan.bmc.modules.content.events.BMCEntryEvent;

	public class ListModerationCommand extends BorhanCommand implements ICommand, IResponder
	{
		private var _currentEntry : BorhanBaseEntry;
		override public function execute(event:CairngormEvent):void
		{
			var e : BMCEntryEvent = event as BMCEntryEvent;
			_currentEntry = e.entryVo;
			var pg:BorhanFilterPager = new BorhanFilterPager();
			pg.pageSize = 500;
			pg.pageIndex = 0;
			var mlf:MediaListFlags= new MediaListFlags(_currentEntry.id,pg);
		 	mlf.addEventListener(BorhanEvent.COMPLETE, result);
			mlf.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mlf);
		}
		
		override public function result(data:Object):void
		{
			var kmflr:BorhanModerationFlagListResponse;
			var kmf:BorhanModerationFlag;
			_model.moderationModel.moderationsArray.source = data.data.objects as Array;
		}
	}
}