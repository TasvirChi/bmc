package com.borhan.bmc.modules.content.commands.live {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.liveStream.LiveStreamAdd;
	import com.borhan.edw.control.DataTabController;
	import com.borhan.edw.control.KedController;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.ModelEvent;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.commands.BorhanCommand;
	import com.borhan.bmc.modules.content.events.AddStreamEvent;
	import com.borhan.bmc.modules.content.events.WindowEvent;
	import com.borhan.bmc.modules.content.vo.StreamVo;
	import com.borhan.bmvc.control.BMvCEvent;
	import com.borhan.types.BorhanDVRStatus;
	import com.borhan.types.BorhanLivePublishStatus;
	import com.borhan.types.BorhanMediaType;
	import com.borhan.types.BorhanPlaybackProtocol;
	import com.borhan.types.BorhanRecordStatus;
	import com.borhan.types.BorhanSourceType;
	import com.borhan.vo.BorhanLiveStreamConfiguration;
	import com.borhan.vo.BorhanLiveStreamEntry;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("live")]
	
	public class AddStreamCommand extends BorhanCommand {

		private var _sourceType:String = null;
		
		private var _createdEntryId:String;
		
		
		
		override public function execute(event:CairngormEvent):void {
			var streamVo:StreamVo = (event as AddStreamEvent).streamVo;
			var liveEntry:BorhanLiveStreamEntry = new BorhanLiveStreamEntry();
			liveEntry.mediaType = BorhanMediaType.LIVE_STREAM_FLASH;

			liveEntry.name = streamVo.streamName;
			liveEntry.description = streamVo.description;
			
			if (streamVo.streamType == StreamVo.STREAM_TYPE_UNIVERSAL) {
				setAkamaiUniversalParams(liveEntry, streamVo);
				_sourceType = BorhanSourceType.AKAMAI_UNIVERSAL_LIVE;
			}
			else if (streamVo.streamType == StreamVo.STREAM_TYPE_MANUAL) {
				setManualParams(liveEntry, streamVo);
				_sourceType = BorhanSourceType.MANUAL_LIVE_STREAM;
			}
			else if (streamVo.streamType == StreamVo.STREAM_TYPE_BORHAN) {
				setBorhanLiveParams(liveEntry, streamVo);
				_sourceType = BorhanSourceType.LIVE_STREAM;
			}
			else if (streamVo.streamType == StreamVo.STREAM_TYPE_MULTICAST) {
				setMulticastParams(liveEntry, streamVo);
				_sourceType = BorhanSourceType.LIVE_STREAM;
			}

			var addEntry:LiveStreamAdd = new LiveStreamAdd(liveEntry, _sourceType);
			addEntry.addEventListener(BorhanEvent.COMPLETE, result);
			addEntry.addEventListener(BorhanEvent.FAILED, fault);
			_model.increaseLoadCounter();
			_model.context.kc.post(addEntry);
		}
		
		
		/**
		 * set parameters relevant to Borhan multicast live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setMulticastParams(liveEntry:BorhanLiveStreamEntry, streamVo:StreamVo):void {
			liveEntry.dvrStatus = BorhanDVRStatus.DISABLED;
			
			// recording
			if (streamVo.recordingEnabled) {
				liveEntry.recordStatus = parseInt(streamVo.recordingType);
				
			}
			else {
				liveEntry.recordStatus = BorhanRecordStatus.DISABLED;
			}
			
			liveEntry.conversionProfileId = streamVo.conversionProfileId;
			
			liveEntry.pushPublishEnabled = BorhanLivePublishStatus.ENABLED; 
		}		
		
		
		/**
		 * set parameters relevant to Borhan live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setBorhanLiveParams(liveEntry:BorhanLiveStreamEntry, streamVo:StreamVo):void {
			// dvr
			if (streamVo.dvrEnabled) {
				liveEntry.dvrStatus = BorhanDVRStatus.ENABLED;
				liveEntry.dvrWindow = 120; // 2 hours, in minutes
			}
			else {
				liveEntry.dvrStatus = BorhanDVRStatus.DISABLED;
			}
			// recording
			if (streamVo.recordingEnabled) {
				liveEntry.recordStatus = parseInt(streamVo.recordingType);
			}
			else {
				liveEntry.recordStatus = BorhanRecordStatus.DISABLED;
			}
			
			liveEntry.conversionProfileId = streamVo.conversionProfileId;
		}
		
		
		/**
		 * set parameters relevant to manual live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setManualParams(liveEntry:BorhanLiveStreamEntry, streamVo:StreamVo):void {
			liveEntry.hlsStreamUrl = streamVo.mobileHLSURL; // legacy, empty value is ok
			liveEntry.liveStreamConfigurations = new Array();
			var cfg:BorhanLiveStreamConfiguration;
			// add config for hls
			if (streamVo.mobileHLSURL) {
				cfg = new BorhanLiveStreamConfiguration();
				cfg.protocol = BorhanPlaybackProtocol.APPLE_HTTP;
				cfg.url = streamVo.mobileHLSURL;
				liveEntry.liveStreamConfigurations.push(cfg);
			}
			// add config for hds
			if (streamVo.flashHDSURL) {
				cfg = new BorhanLiveStreamConfiguration();
				if (streamVo.isAkamaiHds) {
					cfg.protocol = BorhanPlaybackProtocol.AKAMAI_HDS;
				}
				else {
					cfg.protocol = BorhanPlaybackProtocol.HDS;
				}
				cfg.url = streamVo.flashHDSURL;
				liveEntry.liveStreamConfigurations.push(cfg);
			}
		}
		
		
		/**
		 * set parameters relevant to Akamai universal live streams 
		 * @param liveEntry	entry to manipulate
		 * @param streamVo	data
		 */
		private function setAkamaiUniversalParams(liveEntry:BorhanLiveStreamEntry, streamVo:StreamVo):void {
			liveEntry.encodingIP1 = streamVo.primaryIp;
			liveEntry.encodingIP2 = streamVo.secondaryIp;
			
			if (streamVo.dvrEnabled) {
				liveEntry.dvrStatus = BorhanDVRStatus.ENABLED;
				liveEntry.dvrWindow = 30;
			}
			else {
				liveEntry.dvrStatus = BorhanDVRStatus.DISABLED;
			}
			
			if (!streamVo.password)
				liveEntry.streamPassword = "";
			else
				liveEntry.streamPassword = streamVo.password;
		}		
		

		override public function result(data:Object):void {
			super.result(data);
			_createdEntryId = (data.data as BorhanLiveStreamEntry).id;
			var rm:IResourceManager = ResourceManager.getInstance();
			if (_sourceType == BorhanSourceType.MANUAL_LIVE_STREAM) {
				Alert.show(rm.getString('live', 'manualLiveEntryCreatedMessage', [_createdEntryId]), rm.getString('live', 'manualLiveEntryCreatedMessageTitle'));
			}
			else if (_sourceType == BorhanSourceType.LIVE_STREAM) {
				showBorhanLiveCreaetedMessage();
			}
			else {
				Alert.show(rm.getString('live', 'liveEntryTimeMessage'), rm.getString('live', 'liveEntryTimeMessageTitle'));
			}
			
			_model.decreaseLoadCounter();

			var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
			cgEvent.dispatch();

			var searchEvent2:SearchEvent = new SearchEvent(SearchEvent.SEARCH_ENTRIES, _model.listableVo);
			KedController.getInstance().dispatch(searchEvent2);
		}
		
		
		private function showBorhanLiveCreaetedMessage():void {
			var rm:IResourceManager = ResourceManager.getInstance();
			Alert.show(rm.getString('live', 'borhanLiveEntryCreatedMessage'), rm.getString('live', 'liveEntryTimeMessageTitle'), Alert.YES|Alert.NO, null, gotoEntry);
		}
		
		private function gotoEntry(event:CloseEvent):void {
			if (event.detail == Alert.YES) {
				var cg:BMvCEvent = new ModelEvent(ModelEvent.DUPLICATE_ENTRY_DETAILS_MODEL);
				DataTabController.getInstance().dispatch(cg);
				cg = new KedEntryEvent(KedEntryEvent.GET_ENTRY_AND_DRILLDOWN, null, _createdEntryId);
				DataTabController.getInstance().dispatch(cg);
			}
		}
	}
}
