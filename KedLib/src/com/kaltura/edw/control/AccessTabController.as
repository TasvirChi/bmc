package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.AddNewAccessControlProfileCommand;
	import com.borhan.edw.control.commands.ListAccessControlsCommand;
	import com.borhan.edw.control.events.AccessControlEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class AccessTabController extends BMvCController {
		
		public function AccessTabController()
		{
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(AccessControlEvent.ADD_NEW_ACCESS_CONTROL_PROFILE, AddNewAccessControlProfileCommand);
			addCommand(AccessControlEvent.LIST_ACCESS_CONTROLS_PROFILES, ListAccessControlsCommand);
		}
	}
}