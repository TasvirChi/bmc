package com.borhan.edw.control.commands.cuepoints {
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.CuePointsDataPack;
	import com.borhan.bmvc.control.BMvCEvent;
	

	public class ResetCuePointsCount extends KedCommand {

		override public function execute(event:BMvCEvent):void {
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).cuepointsCount = 0;
		}
	}
}