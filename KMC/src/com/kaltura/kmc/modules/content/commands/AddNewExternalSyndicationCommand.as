package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.syndicationFeed.SyndicationFeedAdd;
	import com.borhan.commands.syndicationFeed.SyndicationFeedGetEntryCount;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.ExternalSyndicationEvent;
	import com.borhan.bmc.modules.content.view.window.externalsyndication.popupwindows.ExternalSyndicationNotificationPopUpWindow;
	import com.borhan.vo.BorhanBaseSyndicationFeed;
	import com.borhan.vo.BorhanGenericXsltSyndicationFeed;
	import com.borhan.vo.BorhanSyndicationFeedEntryCount;
	
	import flash.display.DisplayObject;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;
	
	public class AddNewExternalSyndicationCommand extends BorhanCommand implements ICommand, IResponder
	{
		override public function execute(event:CairngormEvent):void
		{
			_model.increaseLoadCounter();
			
			var mr:MultiRequest = new MultiRequest();
			var newFeed:BorhanBaseSyndicationFeed = event.data as BorhanBaseSyndicationFeed;
		 	var addNewFeed:SyndicationFeedAdd = new SyndicationFeedAdd(newFeed);
		 	mr.addAction(addNewFeed);
		 	
		 	var countersAction:SyndicationFeedGetEntryCount = new SyndicationFeedGetEntryCount("{1:result:id}");
		 	mr.addAction(countersAction);
		 	
		 	mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);	   
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			if (data.data[0] is BorhanBaseSyndicationFeed) 
			{
				if (!(data.data[0] is BorhanGenericXsltSyndicationFeed)) {	
					var extFeedPopUp:ExternalSyndicationNotificationPopUpWindow = new ExternalSyndicationNotificationPopUpWindow();
					extFeedPopUp.partnerData = _model.extSynModel.partnerData;
					extFeedPopUp.rootUrl = _model.context.rootUrl;
					extFeedPopUp.flavorParams = _model.filterModel.flavorParams;
		   			extFeedPopUp.feed = data.data[0] as BorhanBaseSyndicationFeed;
		   			extFeedPopUp.feedCountersData = data.data[1] as BorhanSyndicationFeedEntryCount;
					PopUpManager.addPopUp(extFeedPopUp, Application.application as DisplayObject, true);
					PopUpManager.centerPopUp(extFeedPopUp);
				} 
			}
			else if (data.data[0].error) {
				Alert.show(data.data[0].error.message, ResourceManager.getInstance().getString('cms','error'));
			}
			
			_model.decreaseLoadCounter();
			var getFeedsList:ExternalSyndicationEvent = new ExternalSyndicationEvent(ExternalSyndicationEvent.LIST_EXTERNAL_SYNDICATIONS);
			getFeedsList.dispatch();	
		}


	}
}