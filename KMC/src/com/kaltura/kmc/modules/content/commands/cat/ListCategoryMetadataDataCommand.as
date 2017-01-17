package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.metadata.MetadataList;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.vo.CustomMetadataDataVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.business.CategoryFormBuilder;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.model.CategoriesModel;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanCategory;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanMetadata;
	import com.borhan.vo.BorhanMetadataFilter;
	import com.borhan.vo.BorhanMetadataListResponse;
	
	import mx.collections.ArrayCollection;
	
	public class ListCategoryMetadataDataCommand extends BorhanCommand
	{
		
		/**
		 * This command requests the server for the latest valid metadata data, that suits
		 * the current profile id and current profile version
		 * @param event the event that triggered this command
		 * 
		 */		
		override public function execute(event:CairngormEvent):void
		{
			var filterModel:FilterModel = _model.filterModel;
			var catModel:CategoriesModel = _model.categoriesModel;
			if (!filterModel.categoryMetadataProfiles || !catModel.selectedCategory)
				return;
			
			var filter:BorhanMetadataFilter = new BorhanMetadataFilter();
			filter.objectIdEqual = String(catModel.selectedCategory.id);	
			filter.metadataObjectTypeEqual = BorhanMetadataObjectType.CATEGORY;
			var pager:BorhanFilterPager = new BorhanFilterPager();
			
			var listMetadataData:MetadataList = new MetadataList(filter, pager);
			listMetadataData.addEventListener(BorhanEvent.COMPLETE, result);
			listMetadataData.addEventListener(BorhanEvent.FAILED, fault);
			
			_model.context.kc.post(listMetadataData);
		}
		 
		/**
		 * This function handles the response returned from the server 
		 * @param data the data returned from the server
		 * 
		 */		
		override public function result(data:Object):void
		{
			super.result(data);
			
			var metadataResponse:BorhanMetadataListResponse = data.data as BorhanMetadataListResponse;
			
			var filterModel:FilterModel = _model.filterModel;
			var catModel:CategoriesModel = _model.categoriesModel;
			catModel.metadataInfo = new ArrayCollection;
			
			//go over all profiles and match to the metadata data
			for (var i:int = 0; i<filterModel.categoryMetadataProfiles.length; i++) {
				var categoryMetadata:CustomMetadataDataVO = new CustomMetadataDataVO(); 
				catModel.metadataInfo.addItem(categoryMetadata);
				
				// get the form builder that matches this profile:
				var formBuilder:CategoryFormBuilder = filterModel.categoryFormBuilders[i] as CategoryFormBuilder;
				formBuilder.metadataInfo = categoryMetadata;
				
				// add the BorhanMetadata of this profile to the EntryMetadataDataVO
				var profileId:int = (filterModel.categoryMetadataProfiles[i] as BMCMetadataProfileVO).profile.id;
				for each (var metadata:BorhanMetadata in metadataResponse.objects) {
					if (metadata.metadataProfileId == profileId) {
						categoryMetadata.metadata = metadata;
						break;
					}
				}
				formBuilder.updateMultiTags();
			}
		}
	}
}