package com.borhan.edw.control.commands.cuepoints
{
	import com.borhan.commands.cuePoint.CuePointCount;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.CuePointEvent;
	import com.borhan.edw.model.datapacks.CuePointsDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanCuePointFilter;
	
	public class CountCuePoints extends KedCommand {
		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();		
			var e : CuePointEvent = event as CuePointEvent;
			var f:BorhanCuePointFilter = new BorhanCuePointFilter();
			f.entryIdEqual = e.data;
			var cnt:CuePointCount = new CuePointCount(f);
			
			cnt.addEventListener(BorhanEvent.COMPLETE, result);
			cnt.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(cnt);	 
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			
			(_model.getDataPack(CuePointsDataPack) as CuePointsDataPack).cuepointsCount = parseInt(data.data);
			 
		}
	}
}