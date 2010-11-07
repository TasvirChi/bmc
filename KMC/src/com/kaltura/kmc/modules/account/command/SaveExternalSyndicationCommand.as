package com.kaltura.kmc.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.kmc.modules.account.model.KMCModelLocator;
	
	import mx.rpc.IResponder;
	
	public class SaveExternalSyndicationCommand implements ICommand, IResponder
	{
		private var _model : KMCModelLocator = KMCModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			event.target;
		}
		
		public function result(data:Object):void
		{
			_model.loadingFlag = false;
			
			_model.partnerInfoLoaded = true;
		}
		
		public function fault(info:Object):void
		{
			_model.loadingFlag = false;
			if(info && info.error && info.error.errorMsg && info.error.errorMsg.toString().indexOf("Invalid KS") > -1 )
			{
				ExternalInterface.call("kmc.functions.expired");
				return;
			}
		}
		

	}
}