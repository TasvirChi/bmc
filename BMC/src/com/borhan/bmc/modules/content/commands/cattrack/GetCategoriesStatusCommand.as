package com.borhan.bmc.modules.content.commands.cattrack
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.partner.PartnerListFeatureStatus;
	import com.borhan.edw.business.KedJSGate;
	import com.borhan.edw.model.types.APIErrorCode;
	import com.borhan.errors.BorhanError;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.types.BorhanFeatureStatusType;
	import com.borhan.vo.BorhanFeatureStatus;
	import com.borhan.vo.BorhanFeatureStatusListResponse;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class GetCategoriesStatusCommand extends BorhanCommand {
		
		
		override public function execute(event:CairngormEvent):void {
			var mr:PartnerListFeatureStatus = new PartnerListFeatureStatus();
			mr.useTimeout = false; // if a TO is encountered, it lowers the loadCounter below 0.
			mr.addEventListener(BorhanEvent.COMPLETE, result);
			mr.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(mr);
			
		}
		
		override public function result(data:Object):void {
			var isErr:Boolean = checkError(data);
			if (!isErr) {
				var dsp:EventDispatcher = new EventDispatcher();
				var kfslr:BorhanFeatureStatusListResponse = data.data as BorhanFeatureStatusListResponse;
				var lockFlagFound:Boolean;
				var updateFlagFound:Boolean;
				var updateEntsFlagFound:Boolean;
				for each (var kfs:BorhanFeatureStatus in kfslr.objects) {
					switch (kfs.type) {
						case BorhanFeatureStatusType.LOCK_CATEGORY:
							lockFlagFound = true;
							updateFlagFound = true;
							break;
						case BorhanFeatureStatusType.CATEGORY:
							updateFlagFound = true;
							break;
					}
				}
				
				// lock flag
				if (lockFlagFound) {
					_model.filterModel.setCatLockFlag(true);
				}
				else  {
					_model.filterModel.setCatLockFlag(false);
				}
				
				// update flag
				if (updateFlagFound) {
					_model.filterModel.setCatUpdateFlag(true);
				}
				else {
					_model.filterModel.setCatUpdateFlag(false);
				}
				
				
			}
		}
		
		override public function fault(info:Object):void {
			if (!info || !(info is BorhanEvent)) return;
			
			var er:BorhanError = (info as BorhanEvent).error;
			if (!er) return;
			
			trace("GetCategoriesStatusCommand.fault:", er.errorCode);
			if (er.errorCode == APIErrorCode.INVALID_KS) {
				KedJSGate.expired();
			}
			else if (er.errorCode == APIErrorCode.SERVICE_FORBIDDEN) {
				KedJSGate.expired();
			}
			else if (er.errorMsg) {
				// only show error messages if they are "real errors" 
				// (for some reason, sometimes this call fails, in this  
				// case we get a flash error which we don't want to show)
				if (er.errorCode != IOErrorEvent.IO_ERROR) {
					var alert:Alert = Alert.show(er.errorMsg, ResourceManager.getInstance().getString('cms', 'error'));
				}
			}
		}
	}
}