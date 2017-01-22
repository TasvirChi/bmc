package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.edw.business.EntryUtil;
	import com.borhan.vo.BorhanBaseEntry;

	public class UpdateEntryInListCommand extends BorhanCommand {
		
		override public function execute(event:CairngormEvent):void {
			//if in the entries list there's an entry with the same id, replace it.
			EntryUtil.updateSelectedEntryInList((event.data as BorhanBaseEntry), _model.listableVo.arrayCollection);
		}
	}
}