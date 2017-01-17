package com.borhan.edw.control.commands.customData {
	import com.borhan.commands.metadata.MetadataList;
	import com.borhan.edw.business.EntryFormBuilder;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.MetadataDataEvent;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.CustomDataDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.edw.vo.CustomMetadataDataVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanMetadata;
	import com.borhan.vo.BorhanMetadataFilter;
	import com.borhan.vo.BorhanMetadataListResponse;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class sends a metadata data list request to the server and handles the response
	 * @author Michal
	 *
	 */
	public class ListMetadataDataCommand extends KedCommand {

		private var _filterModel:FilterModel;


		/**
		 * This command requests the server for the latest valid metadata data, that suits
		 * the current profile id and current profile version
		 * @param event the event that triggered this command
		 *
		 */
		override public function execute(event:BMvCEvent):void {
			_filterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
			
			if (event.type == MetadataDataEvent.RESET) {
				var metadataEmptyData:Array = new Array;
				var kMetadata:BorhanMetadata;
				var prof:BMCMetadataProfileVO;
				for (var i:int = 0; i < _filterModel.metadataProfiles.length; i++) {
					prof = _filterModel.metadataProfiles[i] as BMCMetadataProfileVO;
					kMetadata = new BorhanMetadata();
					kMetadata.metadataProfileId = prof.profile.id;
					metadataEmptyData.push(kMetadata);
				}
				setDataToModel(metadataEmptyData);
			}
			else { // list
				
				var edp:EntryDataPack = _model.getDataPack(EntryDataPack) as EntryDataPack;
				if (!_filterModel.metadataProfiles || !edp.selectedEntry.id)
					return;

				var filter:BorhanMetadataFilter = new BorhanMetadataFilter();
				filter.objectIdEqual = edp.selectedEntry.id;

				var listMetadataData:MetadataList = new MetadataList(filter);
				listMetadataData.addEventListener(BorhanEvent.COMPLETE, result);
				listMetadataData.addEventListener(BorhanEvent.FAILED, fault);

				_client.post(listMetadataData);
			}
		}


		/**
		 * This function handles the response returned from the server
		 * @param data the data returned from the server
		 *
		 */
		override public function result(data:Object):void {
			super.result(data);
			var metadataResponse:BorhanMetadataListResponse = data.data as BorhanMetadataListResponse;
			setDataToModel(metadataResponse.objects);
		}


		/**
		 * match given data to profiles and form builders
		 * @param metadataArray entry metadata data
		 */
		private function setDataToModel(metadataArray:Array):void {
			var cddp:CustomDataDataPack = _model.getDataPack(CustomDataDataPack) as CustomDataDataPack;
			cddp.metadataInfoArray = new ArrayCollection();

			//go over all profiles and match to the metadata data
			for (var i:int = 0; i < _filterModel.metadataProfiles.length; i++) {
				var entryMetadata:CustomMetadataDataVO = new CustomMetadataDataVO();
				cddp.metadataInfoArray.addItem(entryMetadata);

				// get the form builder that matches this profile:
				var formBuilder:EntryFormBuilder = _filterModel.formBuilders[i] as EntryFormBuilder;
				formBuilder.metadataInfo = entryMetadata;

				// add the BorhanMetadata of this profile to the EntryMetadataDataVO
				var profileId:int = (_filterModel.metadataProfiles[i] as BMCMetadataProfileVO).profile.id;
				for each (var metadata:BorhanMetadata in metadataArray) {
					if (metadata.metadataProfileId == profileId) {
						entryMetadata.metadata = metadata;
						break;
					}
				}
				formBuilder.updateMultiTags();
			}
		}

	}
}
