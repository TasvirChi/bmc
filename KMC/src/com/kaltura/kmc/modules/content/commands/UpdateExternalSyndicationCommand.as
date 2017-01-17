package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.events.ExternalSyndicationEvent;
	import com.borhan.commands.syndicationFeed.SyndicationFeedUpdate;
	import com.borhan.events.BorhanEvent;
	import com.borhan.vo.BorhanBaseSyndicationFeed;
	
	import mx.rpc.IResponder;
	
	public class UpdateExternalSyndicationCommand extends BorhanCommand implements ICommand, IResponder
	{
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var feed:BorhanBaseSyndicationFeed = event.data as BorhanBaseSyndicationFeed;
			var id:String = feed.id;
//			feed.id = null;
//			feed.type = "";
//			feed.feedUrl = null;
//			feed.partnerId = int.MIN_VALUE;
//			feed.status = int.MIN_VALUE;
//			feed.createdAt = int.MIN_VALUE;
			feed.setUpdatedFieldsOnly(true);
		
		 	var updateFeed:SyndicationFeedUpdate = new SyndicationFeedUpdate(id, feed);
		 	updateFeed.addEventListener(BorhanEvent.COMPLETE, result);
			updateFeed.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(updateFeed);	   
		}

		override public function result(data:Object):void
		{
			_model.decreaseLoadCounter();
			var feedListEvent:ExternalSyndicationEvent = new ExternalSyndicationEvent(ExternalSyndicationEvent.LIST_EXTERNAL_SYNDICATIONS);
			feedListEvent.dispatch();
		}

	}
}