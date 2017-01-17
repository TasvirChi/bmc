package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.types.WindowsStates;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.bmc.modules.content.events.BMCEntryEvent;

	public class PreviewCommand extends BorhanCommand
	{
		override public function execute(event:CairngormEvent):void
		{
			(_model.entryDetailsModel.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry = (event as BMCEntryEvent).entryVo;
			_model.windowState = WindowsStates.PREVIEW;
		}
	}
}