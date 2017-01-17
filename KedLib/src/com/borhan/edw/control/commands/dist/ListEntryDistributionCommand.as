package com.borhan.edw.control.commands.dist
{
	import com.borhan.commands.entryDistribution.EntryDistributionList;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.EntryDistributionWithProfile;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanEntryDistributionStatus;
	import com.borhan.vo.BorhanDistributionProfile;
	import com.borhan.vo.BorhanEntryDistribution;
	import com.borhan.vo.BorhanEntryDistributionFilter;
	import com.borhan.vo.BorhanEntryDistributionListResponse;
	
	public class ListEntryDistributionCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void
		{
			_model.increaseLoadCounter();
			var entryDistributionFilter:BorhanEntryDistributionFilter = new BorhanEntryDistributionFilter();
			entryDistributionFilter.entryIdEqual = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry.id;	
			var listEntryDistribution:EntryDistributionList = new EntryDistributionList(entryDistributionFilter);
			listEntryDistribution.addEventListener(BorhanEvent.COMPLETE, result);
			listEntryDistribution.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(listEntryDistribution);

		}
		
		override public function result(data:Object):void
		{
			_model.decreaseLoadCounter();	
			super.result(data);

			var result:BorhanEntryDistributionListResponse = data.data as BorhanEntryDistributionListResponse;
			handleEntryDistributionResult(result);	
		}
		
		public function handleEntryDistributionResult(result:BorhanEntryDistributionListResponse):void 
		{
			var ddp:DistributionDataPack = _model.getDataPack(DistributionDataPack) as DistributionDataPack;
			var distributionArray:Array = [];
			var profilesArray:Array = ddp.distributionInfo.distributionProfiles;
			for each (var distribution:BorhanEntryDistribution in result.objects) {
				if (distribution.status != BorhanEntryDistributionStatus.DELETED) {
					for each (var profile:BorhanDistributionProfile in profilesArray) {
						if (distribution.distributionProfileId == profile.id) {
							var newEntryDistribution:EntryDistributionWithProfile = new EntryDistributionWithProfile();
							newEntryDistribution.borhanDistributionProfile = profile;
							newEntryDistribution.borhanEntryDistribution = distribution;
							distributionArray.push(newEntryDistribution);
						} 
					}
				}
			}
			
			ddp.distributionInfo.entryDistributions = distributionArray;
		}
	}
}