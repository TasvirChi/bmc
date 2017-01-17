package com.borhan.edw.model.datapacks
{
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.edw.control.events.ThumbnailAssetEvent;
	import com.borhan.edw.vo.DistributionInfo;
	import com.borhan.events.FileUploadEvent;
	import com.borhan.bmvc.control.BMvCController;
	import com.borhan.bmvc.model.IDataPack;
	import com.borhan.managers.FileUploadManager;
	import com.borhan.types.BorhanMediaType;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanMixEntry;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * information required for distribution of the current entry
	 * */
	public class DistributionDataPack implements IDataPack {
		
		public var shared:Boolean = false;
		
		/**
		 * contains all info regarding distribution profiles: distribution profiles and thumbnails 
		 */		
		public var distributionInfo:DistributionInfo = new DistributionInfo();
		
		
		/**
		 * FlavorAssetWithParamsVO objects 
		 * used for entry drilldown > flavors, distribution
		 */		
		public var flavorParamsAndAssetsByEntryId:ArrayCollection = new ArrayCollection();
		
		/**
		 * Indicates whether flavors were loaded 
		 * used in DistributionDetailsWindow
		 * */
		public var flavorsLoaded:Boolean = false;
		
		/**
		 * Holds a reference to the current entry to check whether it changed or not when loadThumbs is called. 
		 */		
		private var _thumbRequestorEntry:BorhanBaseEntry;
		
		/**
		 * Holds a reference to the current entry to check whether it changed or not when loadFlavors is called. 
		 */		
		private var _flavorRequestorEntry:BorhanBaseEntry;
		
		private var _flavorController:BMvCController;
		
		private var _listenToUpload:Boolean = false;
		private var _refreshOnce:Boolean = false;
		private var _timeoutTimer:Timer = new Timer(5,1);
		
		public function loadThumbs(controller:BMvCController, currEntry:BorhanBaseEntry):void{
			if (_thumbRequestorEntry != currEntry){
				_thumbRequestorEntry = currEntry;
				var listThumbs:ThumbnailAssetEvent = new ThumbnailAssetEvent(ThumbnailAssetEvent.LIST);
				controller.dispatch(listThumbs);
			}
		}
		
		public function loadFlavors(controller:BMvCController, currEntry:BorhanBaseEntry):void{
			if (_flavorRequestorEntry != currEntry){
				_flavorRequestorEntry = currEntry;
				_flavorController = controller;
				if (!_listenToUpload) {
					FileUploadManager.getInstance().addEventListener(FileUploadEvent.UPLOAD_STARTED, onFlavorsChanged);
					_listenToUpload = true;
				}
				
				refreshFlavors();
			}
		}
		
		public function clearFlavorUpdates():void{
			if (_listenToUpload){
				FileUploadManager.getInstance().removeEventListener(FileUploadEvent.UPLOAD_STARTED, onFlavorsChanged);
				_listenToUpload = false;
			}
		}
		
		/**
		 * since refreshFlavors is triggered by both set status and set replacementStatus on FlavorsTab,
		 * we get a redundant call if both change. this function removes one call.
		 * */
		public function refreshFlavors():void{
			if (!_timeoutTimer.running && _flavorRequestorEntry) {
				_timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, refreshOnce);
				_timeoutTimer.start();
			}
		}
		
		private function refreshOnce(event:TimerEvent):void {
			_timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, refreshOnce);
			_timeoutTimer.reset();
			refreshData(false);
		}
		
		private function refreshData(refreshEntry:Boolean):void {
			if (_flavorRequestorEntry != null) {
				var cgEvent:KedEntryEvent = new KedEntryEvent(KedEntryEvent.GET_FLAVOR_ASSETS, _flavorRequestorEntry);
				_flavorController.dispatch(cgEvent);
				if (refreshEntry) {
					cgEvent = new KedEntryEvent(KedEntryEvent.UPDATE_SELECTED_ENTRY_REPLACEMENT_STATUS, null, _flavorRequestorEntry.id);
					_flavorController.dispatch(cgEvent);
				}
				
			}
		}
		
		
		private function onFlavorsChanged(event:Event):void {
			refreshData(true);
		}
	}
}