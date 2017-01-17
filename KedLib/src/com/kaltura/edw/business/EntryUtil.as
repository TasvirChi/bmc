package com.borhan.edw.business {
	import com.borhan.analytics.GoogleAnalyticsConsts;
	import com.borhan.analytics.GoogleAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTrackerConsts;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.vo.FlavorAssetWithParamsVO;
	import com.borhan.bmvc.model.IDataPackRepository;
	import com.borhan.types.BorhanStatsBmcEventType;
	import com.borhan.utils.ObjectUtil;
	import com.borhan.utils.SoManager;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanFlavorAsset;
	import com.borhan.vo.BorhanLiveStreamBitrate;
	import com.borhan.vo.BorhanLiveStreamEntry;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanPlayableEntry;
	
	import mx.collections.ArrayCollection;

	/**
	 * This class will hold functions related to borhan entries
	 * @author Michal
	 *
	 */
	public class EntryUtil {

		/**
		 * Update the given entry on the listableVO list, if it contains an entry with the same id
		 *
		 */
		public static function updateSelectedEntryInList(entryToUpdate:BorhanBaseEntry, entries:ArrayCollection):void {
			for each (var entry:BorhanBaseEntry in entries) {
				if (entry.id == entryToUpdate.id) {

					var atts:Array = ObjectUtil.getObjectAllKeys(entryToUpdate);
					var att:String;
					for (var i:int = 0; i < atts.length; i++) {
						att = atts[i];
						if (entry[att] != entryToUpdate[att]) {
							entry[att] = entryToUpdate[att];
						}
					}
					break;
				}
			}
		}


		/**
		 * In order not to override data that was inserted by the user, update only status & replacement fiedls that
		 * might have changed
		 * */
		public static function updateChangebleFieldsOnly(newEntry:BorhanBaseEntry, oldEntry:BorhanBaseEntry):void {
			oldEntry.status = newEntry.status;
			oldEntry.replacedEntryId = newEntry.replacedEntryId;
			oldEntry.replacingEntryId = newEntry.replacingEntryId;
			oldEntry.replacementStatus = newEntry.replacementStatus;
			(oldEntry as BorhanPlayableEntry).duration = (newEntry as BorhanPlayableEntry).duration;
			(oldEntry as BorhanPlayableEntry).msDuration = (newEntry as BorhanPlayableEntry).msDuration;
		}


		/**
		 * open preview and embed window for the given entry according to the data on the given model
		 * */
		public static function openPreview(selectedEntry:BorhanBaseEntry, model:IDataPackRepository, previewOnly:Boolean):void {
			//TODO eliminate, use the function triggered in WindowsManager.as

			var context:ContextDataPack = model.getDataPack(ContextDataPack) as ContextDataPack;
			if (context.openPlayerFunc) {
				var bitrates:Array;
				if (selectedEntry is BorhanLiveStreamEntry) {
					bitrates = [];
					var o:Object;
					for each (var br:BorhanLiveStreamBitrate in selectedEntry.bitrates) {
						o = new Object();
						o.bitrate = br.bitrate;
						o.width = br.width;
						o.height = br.height;
						bitrates.push(o);
					}
				}
				var duration:int = 0;
				if (selectedEntry is BorhanMediaEntry) {
					duration = (selectedEntry as BorhanMediaEntry).duration;
				}
				KedJSGate.doPreviewEmbed(context.openPlayerFunc, selectedEntry.id, selectedEntry.name, selectedEntry.description, 
					previewOnly, false, null, bitrates, duration, selectedEntry.thumbnailUrl);
			}
			GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_OPEN_PREVIEW_AND_EMBED, GoogleAnalyticsConsts.CONTENT);
			KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT, BorhanStatsBmcEventType.CONTENT_OPEN_PREVIEW_AND_EMBED, "content>Open Preview and Embed");

			//First time funnel
			if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED))
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYER_EMBED, GoogleAnalyticsConsts.CONTENT);
		}


		/**
		 * extract flavor assets from the given list
		 * @param flavorParamsAndAssetsByEntryId
		 * */
		private static function allFlavorAssets(flavorParamsAndAssetsByEntryId:ArrayCollection):Array {
			var fa:BorhanFlavorAsset;
			var result:Array = new Array();
			for each (var kawp:FlavorAssetWithParamsVO in flavorParamsAndAssetsByEntryId) {
				fa = kawp.borhanFlavorAssetWithParams.flavorAsset;
				if (fa) {
					result.push(fa);
				}
			}
			return result;
		}
	}
}
