package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.edw.control.KedController;
	import com.borhan.bmc.modules.content.events.BMCSearchEvent;

	/**
	 * this command adds some BMC specific actions around the list action 
	 * @author Atar
	 */	
	public class DoSearchSequenceCommand extends BorhanCommand {
		
		
		override public function execute(event:CairngormEvent):void {
			var e:BMCSearchEvent = event as BMCSearchEvent;
			// reset selected entries list
			_model.selectedEntries = new Array();
			// search for new entries
			var cgEvent:SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES, e.listableVo);
			KedController.getInstance().dispatch(cgEvent);
			// reset the refresh required flag
			_model.refreshEntriesRequired = false;
		}
	}
}