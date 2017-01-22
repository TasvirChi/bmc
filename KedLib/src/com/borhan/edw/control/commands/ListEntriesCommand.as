package com.borhan.edw.control.commands
{
	import com.borhan.commands.baseEntry.BaseEntryList;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.edw.vo.ListableVo;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanBaseEntryFilter;
	import com.borhan.vo.BorhanBaseEntryListResponse;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanMixEntry;
	
	import mx.collections.ArrayCollection;

	public class ListEntriesCommand extends KedCommand
	{
		private var _caller:ListableVo;
		
		/**
		 * @inheritDoc
		 */		
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			_caller = (event as SearchEvent).listableVo;
			var getMediaList:BaseEntryList = new BaseEntryList(_caller.filterVo as BorhanBaseEntryFilter ,_caller.pagingComponent.borhanFilterPager );
		 	getMediaList.addEventListener(BorhanEvent.COMPLETE, result);
			getMediaList.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(getMediaList);	  
		}

		/**
		 * @inheritDoc
		 */
		override public function result(data:Object):void
		{
			super.result(data);
			// the following variables are used to force  
			// their types to compile into the application
			var kme:BorhanMediaEntry; 
			var kbe:BorhanBaseEntry;
			var mix:BorhanMixEntry;
			var recivedData:BorhanBaseEntryListResponse = BorhanBaseEntryListResponse(data.data);
			// only use object we can handle
			var tempAr:Array = [];
			for each (var o:Object in recivedData.objects) {
				if (o is BorhanBaseEntry) {
					tempAr.push(o);
				}
			}
			_caller.arrayCollection = new ArrayCollection (tempAr);
			_caller.pagingComponent.totalCount = recivedData.totalCount;
			_model.decreaseLoadCounter();
		}
		
	}
}