package com.borhan.edw.control.commands.cuepoints
{
	import com.borhan.commands.cuePoint.CuePointAddFromBulk;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.CuePointsDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	
	public class UploadCuePoints extends KedCommand {
		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();		
			var cnt:CuePointAddFromBulk = new CuePointAddFromBulk(event.data);
			
			cnt.addEventListener(BorhanEvent.COMPLETE, result);
			cnt.addEventListener(BorhanEvent.FAILED, fault);
			cnt.queued = false;
			
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).reloadCuePoints = false;
			_client.post(cnt);	 
		}
		
		override public function result(data:Object):void {
			super.result(data);
			//refresh cue points
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).reloadCuePoints = true;
			_model.decreaseLoadCounter();
		}
	}
}