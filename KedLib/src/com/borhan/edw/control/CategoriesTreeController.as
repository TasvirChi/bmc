package com.borhan.edw.control
{
	import com.borhan.edw.control.commands.categories.*;
	import com.borhan.edw.control.events.CategoriesTreeEvent;
	import com.borhan.bmvc.control.BMvCController;

	/**
	 * controller for categories tree
	 * @internal
	 * (not to be confused with BMC content's categories screen) 
	 * @author Atar
	 * 
	 */	
	public class CategoriesTreeController extends BMvCController {
		
		public function CategoriesTreeController() {
			initializeCommands();
		}
		
		public function initializeCommands():void {
			addCommand(CategoriesTreeEvent.LIST_ALL_CATEGORIES, ListAllCategoriesCommand);
			addCommand(CategoriesTreeEvent.LIST_CATEGORIES_UNDER, ListCategoriesUnderCommand);
			addCommand(CategoriesTreeEvent.FLUSH_CATEGORIES, FlushCategoriesDataCommand);
			addCommand(CategoriesTreeEvent.SET_CATEGORIES_DATA_MANAGER_TO_MODEL, SetCategoriesManagerCommand);
		}
		
		
		public function destroy():void {
			for each (var commandName:String in commands) {
				removeCommand(commandName);
			} 
		}
	}
}