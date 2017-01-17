package com.borhan.edw.control.commands.customData {
	import com.borhan.commands.MultiRequest;
	import com.borhan.commands.metadata.MetadataAdd;
	import com.borhan.commands.metadata.MetadataUpdate;
	import com.borhan.edw.business.MetadataDataParser;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.MetadataDataEvent;
	import com.borhan.edw.model.datapacks.CustomDataDataPack;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.edw.model.datapacks.PermissionsDataPack;
	import com.borhan.edw.vo.CustomMetadataDataVO;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanMetadataObjectType;
	import com.borhan.vo.BMCMetadataProfileVO;
	import com.borhan.vo.BorhanBaseEntry;
	
	import mx.collections.ArrayCollection;

	/**
	 * update current entry's custom data 
	 * @author atarsh
	 *
	 */
	public class UpdateMetadataDataCommand extends KedCommand {

		
		override public function execute(event:BMvCEvent):void {
			// custom data info
			var cddp:CustomDataDataPack = _model.getDataPack(CustomDataDataPack) as CustomDataDataPack;
			// use mr to update metadata for all profiles at once
			var mr:MultiRequest = new MultiRequest();
			var keepId:String = event.data;
			
			if ((_model.getDataPack(PermissionsDataPack) as PermissionsDataPack).enableUpdateMetadata && cddp.metadataInfoArray) {
				var metadataProfiles:ArrayCollection = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel.metadataProfiles;
				for (var j:int = 0; j < cddp.metadataInfoArray.length; j++) {
					var metadataInfo:CustomMetadataDataVO = cddp.metadataInfoArray[j] as CustomMetadataDataVO;
					var profile:BMCMetadataProfileVO = metadataProfiles[j] as BMCMetadataProfileVO;
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
								BorhanMetadataObjectType.ENTRY,
								keepId,
								newMetadataXML.toXMLString());
							mr.addAction(metadataAdd);
						}
					}
				}
				
			}
			if (mr.actions.length > 0) {
				_model.increaseLoadCounter();
				// add listeners and post call
				mr.addEventListener(BorhanEvent.COMPLETE, result);
				mr.addEventListener(BorhanEvent.FAILED, fault);
				
				_client.post(mr);
			}
		}


		
		override public function result(data:Object):void {
			_model.decreaseLoadCounter();
			super.result(data);
			checkErrors(data);
		}

	}
}
