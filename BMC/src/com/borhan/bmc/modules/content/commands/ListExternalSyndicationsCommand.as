package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.syndicationFeed.SyndicationFeedList;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.vo.ExternalSyndicationVO;
	import com.borhan.vo.BorhanBaseSyndicationFeed;
	import com.borhan.vo.BorhanBaseSyndicationFeedListResponse;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanGenericSyndicationFeed;
	import com.borhan.vo.BorhanGenericXsltSyndicationFeed;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class ListExternalSyndicationsCommand extends BorhanCommand implements ICommand, IResponder
	{

		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			var kfp:BorhanFilterPager = _model.extSynModel.syndicationFeedsFilterPager;
			if (event.data is BorhanFilterPager) {
				kfp = event.data;
			}
			var listFeeds:SyndicationFeedList = new SyndicationFeedList(_model.extSynModel.syndicationFeedsFilter, kfp);
		 	listFeeds.addEventListener(BorhanEvent.COMPLETE, result);
			listFeeds.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(listFeeds);	  
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
			_model.decreaseLoadCounter();
			var tempArr:ArrayCollection = new ArrayCollection();
			_model.extSynModel.externalSyndications.removeAll();
			var response:BorhanBaseSyndicationFeedListResponse = event.data as BorhanBaseSyndicationFeedListResponse;
			_model.extSynModel.externalSyndicationFeedsTotalCount = response.totalCount;
			
			for each(var feed:Object in response.objects)
			{
				if (feed is BorhanBaseSyndicationFeed) {
					if (feed is BorhanGenericSyndicationFeed && !(feed is BorhanGenericXsltSyndicationFeed)) {
						// in BMC we only support the xslt generic type 
						continue;
					}
					var exSyn:ExternalSyndicationVO = new ExternalSyndicationVO();
					exSyn.kSyndicationFeed = feed as BorhanBaseSyndicationFeed;
					exSyn.id = feed.id;
					tempArr.addItem(exSyn);
				}
			}
			_model.extSynModel.externalSyndications = tempArr;
		}
	}
}