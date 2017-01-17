package com.borhan.bmc.modules.content.commands.cat
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.metadata.MetadataAdd;
	import com.borhan.commands.metadata.MetadataUpdate;
	import com.borhan.edw.business.MetadataDataParser;
	import com.borhan.edw.vo.CustomMetadataDataVO;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanCategory;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	
	public class UpdateCategoryMetadataDataCommand extends BorhanCommand
	{
		override public function execute(event:CairngormEvent):void{
			_model.increaseLoadCounter();
			
			var catid:String = event.data;
			
			var mr:MultiRequest = new MultiRequest();
			
			
			var infoArray:ArrayCollection = _model.categoriesModel.metadataInfo;
			var profileArray:ArrayCollection = _model.filterModel.categoryMetadataProfiles;
			for (var j:int = 0; j < infoArray.length; j++) {
				var metadataInfo:CustomMetadataDataVO = infoArray[j] as CustomMetadataDataVO;
				var profile:BMCMetadataProfileVO = profileArray[j] as BMCMetadataProfileVO;
				if (metadataInfo && profile && profile.profile) {
					var newMetadataXML:XML = MetadataDataParser.toMetadataXML(metadataInfo, profile);
					//metadata exists--> update request
					if (metadataInfo.metadata) {
						var originalMetadataXML:XML = new XML(metadataInfo.metadata.xml);
						if (!(MetadataDataParser.compareMetadata(newMetadataXML, originalMetadataXML))) {
							var metadataUpdate:MetadataUpdate = new MetadataUpdate(metadataInfo.metadata.id,
								newMetadataXML.toXMLString());
							mr.addAction(metadataUpdate);
						}
					}
					else if (newMetadataXML.children().length() > 0) {
						var metadataAdd:MetadataAdd = new MetadataAdd(profile.profile.id,
							BorhanMetadataObjectType.CATEGORY,
							catid,
							newMetadataXML.toXMLString());
						mr.addAction(metadataAdd);
					}
				}
			}
			
			// add listeners and post call
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			
			_model.context.kc.post(mr);
		}
		
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			
			var isErr:Boolean;
			if (data.data && data.data is Array) {
				for (var i:uint = 0; i < (data.data as Array).length; i++) {
					if ((data.data as Array)[i] is BorhanError) {
						isErr = true;
						Alert.show(ResourceManager.getInstance().getString('drilldown', 'error') + ": " +
							((data.data as Array)[i] as BorhanError).errorMsg);
					}
					else if ((data.data as Array)[i].hasOwnProperty("error")) {
						isErr = true;
						Alert.show((data.data as Array)[i].error.message, ResourceManager.getInstance().getString('drilldown', 'error'));
					}
				}
			}
		}
	}
}