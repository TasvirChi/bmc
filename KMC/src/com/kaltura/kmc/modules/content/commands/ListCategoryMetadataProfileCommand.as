package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.metadataProfile.MetadataProfileList;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.CustomDataDataPack;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.business.CategoryFormBuilder;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.types.BorhanMetadataOrderBy;
	import com.borhan.types.BorhanMetadataProfileCreateMode;
	import com.borhan.utils.parsers.MetadataProfileParser;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanMetadataProfile;
	import com.borhan.vo.BorhanMetadataProfileFilter;
	import com.borhan.vo.BorhanMetadataProfileListResponse;
	import com.borhan.vo.MetadataFieldVO;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	public class ListCategoryMetadataProfileCommand extends BorhanCommand
	{
		
		/**
		 * only if a metadata profile view contains layout with this name it will be used
		 */
		private static const BMC_LAYOUT_NAME:String = "BMC";

		
		override public function execute(event:CairngormEvent):void{
			_model.increaseLoadCounter();
			
			var filter:BorhanMetadataProfileFilter = new BorhanMetadataProfileFilter();
			filter.orderBy = BorhanMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = BorhanMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeEqual = BorhanMetadataObjectType.CATEGORY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter);
			listMetadataProfile.addEventListener(BorhanEvent.COMPLETE, result);
			listMetadataProfile.addEventListener(BorhanEvent.FAILED, fault);
			
			_model.context.kc.post(listMetadataProfile);
		}
		
		override public function result(data:Object):void{
			super.result(data);
			_model.decreaseLoadCounter();
			
			if (! checkError(data)){
				var response:BorhanMetadataProfileListResponse = data.data as BorhanMetadataProfileListResponse;
				var metadataProfiles:Array = new Array();
				var formBuilders:Array = new Array();
				if (response.objects) {
					for (var i:int = 0; i < response.objects.length; i++) {
						var recievedProfile:BorhanMetadataProfile = response.objects[i];
						if (recievedProfile) {
							var metadataProfile:BMCMetadataProfileVO = new BMCMetadataProfileVO();
							metadataProfile.profile = recievedProfile;
							metadataProfile.xsd = new XML(recievedProfile.xsd);
							metadataProfile.metadataFieldVOArray = MetadataProfileParser.fromXSDtoArray(metadataProfile.xsd);
							
							//set the displayed label of each label
							for each (var field:MetadataFieldVO in metadataProfile.metadataFieldVOArray) {
								var label:String = ResourceManager.getInstance().getString('customFields', field.defaultLabel);
								if (label) {
									field.displayedLabel = label;
								}
								else {
									field.displayedLabel = field.defaultLabel;
								}
							}
							
							//adds the profile to metadataProfiles, and its matching formBuilder to formBuilders
							metadataProfiles.push(metadataProfile);
							var fb:CategoryFormBuilder = new CategoryFormBuilder(metadataProfile);
							formBuilders.push(fb);
							var isViewExist:Boolean = false;
							
							if (recievedProfile.views) {
								try {
									var recievedView:XML = new XML(recievedProfile.views);
								}
								catch (e:Error) {
									//invalid view xmls
									continue;
								}
								for each (var layout:XML in recievedView.children()) {
									if (layout.@id == BMC_LAYOUT_NAME) {
										metadataProfile.viewXML = layout;
										isViewExist = true;
										continue;
									}
								}
							}
							if (!isViewExist) {
								//if no view was retruned, or no view with "BMC" name, we will set the default uiconf XML
								if (CustomDataDataPack.metadataDefaultUiconfXML){
									metadataProfile.viewXML = CustomDataDataPack.metadataDefaultUiconfXML.copy();
								}
								fb.buildInitialMxml();
							}
						}
					}
				}
				var filterModel:FilterModel = _model.filterModel;
				filterModel.categoryMetadataProfiles = new ArrayCollection(metadataProfiles);
				filterModel.categoryFormBuilders = new ArrayCollection(formBuilders);
			}
		}
	}
}