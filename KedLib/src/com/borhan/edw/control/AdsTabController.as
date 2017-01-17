package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.cuepoints.*;
	import com.borhan.edw.control.events.CuePointEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class AdsTabController extends BMvCController {
		
		public function AdsTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(CuePointEvent.RESET_CUEPOINTS_COUNT, ResetCuePointsCount);
			addCommand(CuePointEvent.COUNT_CUEPOINTS, CountCuePoints);
			addCommand(CuePointEvent.DOWNLOAD_CUEPOINTS, DownloadCuePoints);
			addCommand(CuePointEvent.UPLOAD_CUEPOINTS, UploadCuePoints);
		}
	}
}