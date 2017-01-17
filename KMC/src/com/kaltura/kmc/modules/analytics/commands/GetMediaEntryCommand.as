package com.borhan.bmc.modules.analytics.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.analytics.control.DrillDownEvent;
	import com.borhan.bmc.modules.analytics.model.AnalyticsModelLocator;
	import com.borhan.commands.baseEntry.BaseEntryGet;
	import com.borhan.events.BorhanEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanMixEntry;
	
	import mx.rpc.IResponder;

	public class GetMediaEntryCommand implements ICommand, IResponder
	{
		private var _model : AnalyticsModelLocator = AnalyticsModelLocator.getInstance();
		public function execute(event:CairngormEvent):void
		{
			//get Entry
			_model.loadingFlag = true;
			_model.loadingEntryFlag = true;
			
			if(_model.reportDataMap[_model.currentScreenState].selectedMediaEntry)
				_model.reportDataMap[_model.currentScreenState].selectedMediaEntry = null;
				
			var baseEntryGet : BaseEntryGet = new BaseEntryGet( (event as DrillDownEvent).subjectId );
			baseEntryGet.addEventListener( BorhanEvent.COMPLETE , result );
			baseEntryGet.addEventListener( BorhanEvent.FAILED , fault );
			_model.kc.post( baseEntryGet );
		}
		
		public function result(result:Object):void
		{
			_model.loadingEntryFlag = false;
			_model.checkLoading();
			
			var kme : BorhanBaseEntry; 
			
			if( result.data is BorhanMediaEntry )
				 kme = (result.data as BorhanMediaEntry);
			else if( result.data is BorhanMixEntry )
				 kme = (result.data as BorhanMixEntry);
			else
				kme = result.data;

			_model.reportDataMap[_model.currentScreenState].selectedMediaEntry = kme;
			_model.selectedReportData = null; //refrash
			_model.selectedReportData = _model.reportDataMap[_model.currentScreenState];
		}
		
		public function fault(info:Object):void
		{
			//Test the drill down
			///////////////////////////////////////	
/* 			var kme : BorhanBaseEntry = new BorhanMediaEntry();
			kme.id = "00_e6cf46wd"; //TESTING!!!!!!
			_model.reportDataMap[_model.currentScreenState].selectedMediaEntry = kme; */
			///////////////////////////////////////	
			_model.loadingEntryFlag = false;
			_model.checkLoading();
		}
		
	}
}