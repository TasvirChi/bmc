package com.borhan.edw.control.commands.clips
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.ClipsDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class ResetEntryClipsCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			(_model.getDataPack(ClipsDataPack) as ClipsDataPack).clips = null;
		}
	}
}