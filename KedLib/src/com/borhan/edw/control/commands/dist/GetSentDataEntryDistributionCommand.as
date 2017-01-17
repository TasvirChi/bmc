package com.borhan.edw.control.commands.dist
{
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.EntryDistributionEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanEntryDistribution;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GetSentDataEntryDistributionCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			var entryDis:BorhanEntryDistribution = (event as EntryDistributionEvent).entryDistribution;
			var stringURL:String = _client.protocol + _client.domain + '/api_v3/index.php/service/contentDistribution_entryDistribution/action/serveSentData/actionType/1/id/' +
				entryDis.id + '/ks/' + _client.ks;
			var urlRequest:URLRequest = new URLRequest(stringURL);
			navigateToURL(urlRequest , '_self');
		}
	}
}