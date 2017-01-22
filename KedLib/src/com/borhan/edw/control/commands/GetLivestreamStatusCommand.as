package com.borhan.edw.control.commands
{
	import com.borhan.commands.liveStream.LiveStreamIsLive;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.types.BorhanPlaybackProtocol;

	public class GetLivestreamStatusCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			if (event.type == KedEntryEvent.GET_LIVESTREAM_STATUS) {
				_model.increaseLoadCounter();
				var getStat:LiveStreamIsLive = new LiveStreamIsLive((event as KedEntryEvent).entryVo.id, BorhanPlaybackProtocol.HDS); 
				getStat.addEventListener(BorhanEvent.COMPLETE, result);
				getStat.addEventListener(BorhanEvent.FAILED, fault);
				_client.post(getStat);
			}
			else if (event.type == KedEntryEvent.RESET_LIVESTREAM_STATUS) {
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				edp.selectedLiveEntryIsLive = BorhanNullableBoolean.NULL_VALUE;
			}
		}
		
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data); // look for server errors
			var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
			//data.data is "0" | "1"  
			edp.selectedLiveEntryIsLive = data.data;
		}
	}
}