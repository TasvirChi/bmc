package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.usrs.GetEntitledUsersCommand;
	import com.borhan.edw.control.commands.usrs.GetEntryUserCommand;
	import com.borhan.edw.control.commands.usrs.SetEntryOwnerCommand;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.UsersEvent;
	import com.borhan.bmvc.control.BMvCController;
	
	public class UsersTabController extends BMvCController {
		
		public function UsersTabController() {
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(UsersEvent.GET_ENTRY_OWNER, GetEntryUserCommand);
			addCommand(UsersEvent.GET_ENTRY_CREATOR, GetEntryUserCommand);
			addCommand(UsersEvent.RESET_ENTRY_USERS, GetEntryUserCommand);
			addCommand(UsersEvent.SET_ENTRY_OWNER, SetEntryOwnerCommand);
			addCommand(UsersEvent.GET_ENTRY_EDITORS, GetEntitledUsersCommand);
			addCommand(UsersEvent.GET_ENTRY_PUBLISHERS, GetEntitledUsersCommand);
		}
	}
}