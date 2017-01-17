package com.borhan.edw.control.commands.dist
{
	import com.borhan.commands.entryDistribution.EntryDistributionUpdate;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.EntryDistributionEvent;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanEntryDistribution;

	public class UpdateEntryDistributionCommand extends KedCommand
	{
		private var _entryDis:BorhanEntryDistribution;
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			_entryDis = (event as EntryDistributionEvent).entryDistribution;
			_entryDis.setUpdatedFieldsOnly(true);
			var update:EntryDistributionUpdate = new EntryDistributionUpdate(_entryDis.id, _entryDis);
			update.addEventListener(BorhanEvent.COMPLETE, result);
			update.addEventListener(BorhanEvent.FAILED, fault);
			
			_client.post(update);
		}
		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			var resultEntry:BorhanEntryDistribution = data.data as BorhanEntryDistribution;
			_entryDis =  resultEntry;
			//for data binding
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			ddp.distributionInfo.entryDistributions = ddp.distributionInfo.entryDistributions.concat();
		}
	}
}