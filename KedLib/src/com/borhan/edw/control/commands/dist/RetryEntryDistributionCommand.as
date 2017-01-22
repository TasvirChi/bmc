package com.borhan.edw.control.commands.dist
{
	import com.borhan.commands.entryDistribution.EntryDistributionRetrySubmit;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.EntryDistributionEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanEntryDistribution;

	public class RetryEntryDistributionCommand extends KedCommand
	{
		private var _entryDis:BorhanEntryDistribution;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			_entryDis = (event as EntryDistributionEvent).entryDistribution;
			var retry:EntryDistributionRetrySubmit = new EntryDistributionRetrySubmit(_entryDis.id);
			retry.addEventListener(BorhanEvent.COMPLETE, result);
			retry.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(retry);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var updateResult:BorhanEntryDistribution = data.data as BorhanEntryDistribution;
			_entryDis.status = updateResult.status;

			//for data binding
			
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.entryDistributions = ddp.distributionInfo.entryDistributions.concat();
		}
	}
}