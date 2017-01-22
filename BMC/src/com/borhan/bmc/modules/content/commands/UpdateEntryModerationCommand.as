package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.analytics.GoogleAnalyticsConsts;
	import com.borhan.analytics.GoogleAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTrackerConsts;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.baseEntry.BaseEntryApprove;
	import com.borhan.commands.baseEntry.BaseEntryReject;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.edw.control.KedController;
	import com.borhan.bmc.modules.content.events.CategoryEvent;
	import com.borhan.bmc.modules.content.events.ModerationsEvent;
	import com.borhan.types.BorhanStatsBmcEventType;
	import com.borhan.vo.BorhanBaseEntry;
	
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
    
   
    
	public class UpdateEntryModerationCommand extends BorhanCommand implements ICommand, IResponder
	{
		private var moderationType:int;
		 
		override public function execute(event:CairngormEvent):void
		{
			var entriesToUpdate:Array = (event as ModerationsEvent).entries;
		    moderationType = (event as ModerationsEvent).moderationType;
			
			var mr:MultiRequest = new MultiRequest();
			var i:uint;
			if (moderationType == ModerationsEvent.APPROVE) {
				// approve
				for(i=0; i<entriesToUpdate.length;i++)
				{
	        		var aproveEntry:BaseEntryApprove = new BaseEntryApprove((entriesToUpdate[i] as BorhanBaseEntry).id);
					mr.addAction(aproveEntry);
				}
			}
			else if (moderationType == ModerationsEvent.REJECT) {
				// reject
				for( i = 0; i<entriesToUpdate.length;i++)
				{
	        		var reject:BaseEntryReject = new BaseEntryReject((entriesToUpdate[i] as BorhanBaseEntry).id);
					mr.addAction(reject);
				}
			}
			
			
			// reset the array
			_model.moderationModel.moderationsArray.source = [];
			
			mr.addEventListener(BorhanEvent.COMPLETE,result);
			mr.addEventListener(BorhanEvent.FAILED,fault);

			_model.increaseLoadCounter();
			_model.context.kc.post(mr);
			
		}
			

		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			var searchEvent : SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES , _model.listableVo  );
			KedController.getInstance().dispatch(searchEvent);
			

			//dispatching - single dispatch for each entry
			if(moderationType)
			{
				switch(moderationType){
					case (1):
					for each (var baseEntryApprove:BaseEntryApprove in data.currentTarget.actions )
					{
						GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_APPROVE_MODERATION, GoogleAnalyticsConsts.CONTENT);
				        KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT,BorhanStatsBmcEventType.CONTENT_APPROVE_MODERATION,
																  "Moderation>ApproveSelected");
					}
					break;
					case(2):
					for each (var baseEntryReject:BaseEntryReject in data.currentTarget.actions )
					{
				    	GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_REJECT_MODERATION, GoogleAnalyticsConsts.CONTENT);
						KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT,BorhanStatsBmcEventType.CONTENT_REJECT_MODERATION,
															  "Moderation>RejectSelected");
					}
					break;
				}
			}
		}
	}
}	
