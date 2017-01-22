package com.borhan.edw.control.commands.usrs
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanUser;
	
	public class SetEntryOwnerCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			edp.selectedEntryOwner = event.data as BorhanUser;
		}
	}
}