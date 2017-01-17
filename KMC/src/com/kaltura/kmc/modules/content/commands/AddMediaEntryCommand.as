package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.media.MediaAdd;
	import com.borhan.edw.control.events.MediaEvent;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.types.WindowsStates;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.EntriesEvent;
	import com.borhan.bmc.modules.content.events.WindowEvent;
	import com.borhan.net.BorhanCall;
	import com.borhan.vo.BorhanMediaEntry;
	
	import mx.resources.ResourceManager;

	public class AddMediaEntryCommand extends BorhanCommand {
		//whether to open drilldown after media is created
//		private var _openDrilldown:Boolean;
		
		override public function execute(event:CairngormEvent):void 
		{
			_model.increaseLoadCounter();
			var mediaEvent:EntriesEvent = event as EntriesEvent;
//			_openDrilldown = mediaEvent.openDrilldown;
			var addMedia:MediaAdd = new MediaAdd(mediaEvent.data);

			addMedia.addEventListener(BorhanEvent.COMPLETE, result);
			addMedia.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(addMedia);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			
			if (data.data && (data.data is BorhanMediaEntry)) {
				(_model.entryDetailsModel.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry = data.data as BorhanMediaEntry;
//				if (_openDrilldown) {	
					var cgEvent:WindowEvent = new WindowEvent(WindowEvent.OPEN, WindowsStates.ENTRY_DETAILS_WINDOW_NEW_ENTRY);
					cgEvent.dispatch();
//				}
			}
			else {
				trace ("error in add media");
			}
			
			_model.decreaseLoadCounter();
		}
		
	}
}