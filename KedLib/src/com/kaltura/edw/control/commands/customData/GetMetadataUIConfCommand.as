package com.borhan.edw.control.commands.customData
{
	import com.borhan.commands.uiConf.UiConfGet;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.CustomDataDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanUiConf;
	
	/**
	 * This class will get the default metadata view and save the uiconf xml on the entryDetailsModel.
	 * @author Michal
	 * 
	 */
	public class GetMetadataUIConfCommand extends KedCommand
	{
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();

			var uiconfRequest:UiConfGet = new UiConfGet(CustomDataDataPack.metadataDefaultUiconf);
			uiconfRequest.addEventListener(BorhanEvent.COMPLETE, result);
			uiconfRequest.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(uiconfRequest);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			var result:BorhanUiConf = data.data as BorhanUiConf;
			if (result)
				CustomDataDataPack.metadataDefaultUiconfXML = new XML(result.confFile);
			
			_model.decreaseLoadCounter();
			
		}
	}
}