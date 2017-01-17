package com.borhan.edw.control.commands.customData {
	import com.borhan.commands.metadataProfile.MetadataProfileList;
	import com.borhan.edw.business.EntryFormBuilder;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.FilterModel;
	import com.borhan.edw.model.datapacks.CustomDataDataPack;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.types.BorhanMetadataOrderBy;
	import com.borhan.types.BorhanMetadataProfileCreateMode;
	import com.borhan.utils.parsers.MetadataProfileParser;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanMetadataProfile;
	import com.borhan.vo.BorhanMetadataProfileFilter;
	import com.borhan.vo.BorhanMetadataProfileListResponse;
	import com.borhan.vo.MetadataFieldVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;

	/**
	 * This command is being executed when the event MetadataProfileEvent.LIST is dispatched.
	 * @author Michal
	 *
	 */
	public class ListMetadataProfileCommand extends KedCommand {

		/**
		 * only if a metadata profile view contains layout with this name it will be used
		 */
		public static const BMC_LAYOUT_NAME:String = "BMC";


		/**
		 * This command requests the server for the last created metadata profile
		 * @param event the event that triggered this command
		 *
		 */
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var filter:BorhanMetadataProfileFilter = new BorhanMetadataProfileFilter();
			filter.orderBy = BorhanMetadataOrderBy.CREATED_AT_DESC;
			filter.createModeNotEqual = BorhanMetadataProfileCreateMode.APP;
			filter.metadataObjectTypeEqual = BorhanMetadataObjectType.ENTRY;
			var listMetadataProfile:MetadataProfileList = new MetadataProfileList(filter);
			listMetadataProfile.addEventListener(BorhanEvent.COMPLETE, result);
			listMetadataProfile.addEventListener(BorhanEvent.FAILED, fault);

			_client.post(listMetadataProfile);
		}


		/**
		 * This function handles the response from the server. if a profile returned from the server then it will be
		 * saved into the model.
		 * @param data the data returned from the server
		 *
		 */
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();

			if (data.error) {
				var er:BorhanError = data.error as BorhanError;
				if (er) {
					// ignore service forbidden
					if (er.errorCode != APIErrorCode.SERVICE_FORBIDDEN) {
						Alert.show(er.errorMsg, "Error");
					}
				}
			}
			else {
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
							var fb:EntryFormBuilder = new EntryFormBuilder(metadataProfile);
							formBuilders.push(fb);
							var isViewExist:Boolean = false;
	
							if (recievedProfile.views) {
								var recievedView:XML;
								try {
									recievedView = new XML(recievedProfile.views);
								}
								catch (e:Error) {
									//invalid view xmls
									continue;
								}
								for each (var layout:XML in recievedView.children()) {
									if (layout.@id == ListMetadataProfileCommand.BMC_LAYOUT_NAME) {
										metadataProfile.viewXML = layout;
										isViewExist = true;
										continue;
									}
								}
							}
							if (!isViewExist) {
								//if no view was retruned, or no view with "BMC" name, we will set the default metadata view uiconf XML
								if (CustomDataDataPack.metadataDefaultUiconfXML){
									metadataProfile.viewXML = CustomDataDataPack.metadataDefaultUiconfXML.copy();
								}
								// create the actual view:
								fb.buildInitialMxml();
							}
						}
					}
				}
				var filterModel:FilterModel = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
				filterModel.metadataProfiles = new ArrayCollection(metadataProfiles);
				filterModel.formBuilders = new ArrayCollection(formBuilders);
			}

		}


		/**
		 * This function will be called if the request failed
		 * @param info the info returned from the server
		 *
		 */
		override public function fault(info:Object):void {
			if (info && info.error && info.error.errorMsg && info.error.errorCode != APIErrorCode.SERVICE_FORBIDDEN) {
				Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
			}
			_model.decreaseLoadCounter();
		}
	}
}
