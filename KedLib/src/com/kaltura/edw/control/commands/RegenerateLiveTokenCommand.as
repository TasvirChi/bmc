package com.borhan.edw.control.commands {
	import com.borhan.commands.liveStream.LiveStreamRegenerateStreamToken;
	import com.borhan.edw.events.KedDataEvent;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;

	[ResourceBundle("live")]
	
	public class RegenerateLiveTokenCommand extends KedCommand {

		override public function execute(event:BMvCEvent):void {
			var regenerate:LiveStreamRegenerateStreamToken = new LiveStreamRegenerateStreamToken(event.data);
			regenerate.addEventListener(BorhanEvent.COMPLETE, result);
			regenerate.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_client.post(regenerate);
		}


		override public function result(data:Object):void {
			super.result(data);
			// update the new entry on the model (so in view)
			var e:KedDataEvent = new KedDataEvent(KedDataEvent.ENTRY_UPDATED);
			e.data = data.data; // send the updated entry as event data
			(_model.getDataPack(ContextDataPack) as ContextDataPack).dispatcher.dispatchEvent(e);
			
			_model.decreaseLoadCounter();

		}
	}
}
