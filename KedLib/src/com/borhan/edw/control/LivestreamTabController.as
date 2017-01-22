package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.ListLiveConversionProfilesCommand;
	import com.borhan.edw.control.commands.RegenerateLiveTokenCommand;
	import com.borhan.edw.control.events.LiveEvent;
	import com.borhan.edw.control.events.ProfileEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class LivestreamTabController extends BMvCController {
		
		public function LivestreamTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(ProfileEvent.LIST_LIVE_CONVERSION_PROFILES, ListLiveConversionProfilesCommand);
			addCommand(LiveEvent.REGENERATE_LIVE_TOKEN, RegenerateLiveTokenCommand);
		}
	}
}