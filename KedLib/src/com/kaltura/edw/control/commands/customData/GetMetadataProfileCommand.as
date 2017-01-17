package com.borhan.edw.control.commands.customData
{
	import com.borhan.commands.metadataProfile.MetadataProfileGet;
	import com.borhan.edw.business.EntryFormBuilder;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.MetadataProfileEvent;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanMetadataProfile;

	public class GetMetadataProfileCommand extends KedCommand
	{
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var profileId:int = (event as MetadataProfileEvent).profileId;
			if (profileId != -1) {
				var getMetadataProfile:MetadataProfileGet = new MetadataProfileGet(profileId);
				getMetadataProfile.addEventListener(BorhanEvent.COMPLETE, result);
				getMetadataProfile.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(getMetadataProfile);
			}
		}
		
		override public function result(data:Object):void {
			var recievedProfile:BorhanMetadataProfile = data.data as BorhanMetadataProfile;
			var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			if (recievedProfile) {
				for (var i:int = 0; i<filterModel.metadataProfiles.length; i++) {
					var profile:BMCMetadataProfileVO = filterModel.metadataProfiles[i] as BMCMetadataProfileVO;
					if (profile.profile.id == recievedProfile.id) {
						profile.profile = recievedProfile;
						(filterModel.formBuilders[i] as EntryFormBuilder).metadataProfile = profile;
						break;
					}
				}
			}
			_model.decreaseLoadCounter();
			
		}
	}
}