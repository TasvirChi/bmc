package com.borhan.edw.control.commands
{
	import com.borhan.commands.storageProfile.StorageProfileList;
	import com.borhan.core.KClassFactory;
	import com.borhan.edw.business.ClientUtil;
	import com.borhan.edw.control.commands.KedCommand;
	import com.borhan.edw.model.datapacks.FlavorsDataPack;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.vo.BorhanStorageProfile;
	import com.borhan.vo.BorhanStorageProfileListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class ListStorageProfilesCommand extends KedCommand {
		
		override public function execute(event:BMvCEvent):void {
			_model.increaseLoadCounter();
			var lsp:StorageProfileList = new StorageProfileList();
			lsp.addEventListener(BorhanEvent.COMPLETE, result);
			lsp.addEventListener(BorhanEvent.FAILED, fault);
			_client.post(lsp);
		}
		
		
		override public function result(event:Object):void {
			// error handling
			var er:BorhanError ;
			if (event.error) {
				er = event.error as BorhanError;
				if (er) {
					Alert.show(er.errorMsg, "Error");
				}
			}
			
			// result
			else {
				// assume what we got are remote storage profiles, even if we got something that inherits (ie, object)
				var objects:Array = (event.data as BorhanStorageProfileListResponse).objects;
				var profiles:Array = new Array();
				var profile:BorhanStorageProfile;
				for each (var obj:Object in objects) {
					if (!(obj is BorhanStorageProfile)) {
						profile = ClientUtil.createClassInstanceFromObject(BorhanStorageProfile, obj);
					}
					else {
						profile = obj as BorhanStorageProfile;
					}
					profiles.push(profile);
				}
				
				(_model.getDataPack(FlavorsDataPack) as FlavorsDataPack).storageProfiles = new ArrayCollection(profiles);
			}	
			_model.decreaseLoadCounter();
		}
	}
}