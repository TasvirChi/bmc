package com.borhan.edw.components.et
{
	import com.borhan.types.BorhanEntryModerationStatus;
	import com.borhan.types.BorhanEntryStatus;
	import com.borhan.types.BorhanPlaylistType;
	import com.borhan.utils.KTimeUtil;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanClipAttributes;
	import com.borhan.vo.BorhanLiveEntry;
	import com.borhan.vo.BorhanLiveStreamEntry;
	import com.borhan.vo.BorhanOperationAttributes;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	public class EntryTableLabelFunctions {
		
		
		public static function formatDate(item:Object, column:DataGridColumn):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = ResourceManager.getInstance().getString('cms', 'listdateformat');
			var dt:Date = new Date();
			dt.setTime(item.createdAt * 1000);
			return df.format(dt);
		};

		public static function getPlaylistMediaTypes(item:Object, column:DataGridColumn):String {
			switch (item.playlistType) {
				case BorhanPlaylistType.STATIC_LIST:
					return ResourceManager.getInstance().getString('cms', 'manuall');
					break;
				case BorhanPlaylistType.DYNAMIC:
					return ResourceManager.getInstance().getString('cms', 'ruleBased');
					break;
				case BorhanPlaylistType.EXTERNAL:
					return ResourceManager.getInstance().getString('cms', 'externalRss');
					break;
			}
			return "";
		}
		
		public static function getClipIntime(item:Object, column:DataGridColumn):String {
			var entry:BorhanBaseEntry = item as BorhanBaseEntry;
			var result:String = '';
			for each (var opatt:BorhanOperationAttributes in entry.operationAttributes) {
				if (opatt is BorhanClipAttributes) {
					result = formatTime((opatt as BorhanClipAttributes).offset);
					break;
				}
			}
			return result;
		}
		
		
		private static function formatTime(offset:Number):String {
			var df:DateFormatter = new DateFormatter();
			df.formatString = ResourceManager.getInstance().getString('cms', 'h_m_s_ms');
			var dt:Date = new Date();
			dt.hours = dt.minutes = dt.seconds = 0;
			dt.milliseconds = offset;
			return df.format(dt);
		}
		
		
		/**
		 * format the timer
		 */
		public static function getTimeFormat(item:Object, column:DataGridColumn):String {
			if (item is BorhanLiveEntry) {
				return ResourceManager.getInstance().getString('cms', 'n_a');
			}
			return KTimeUtil.formatTime2(item.duration, true, true);
		}
		
		
		/**
		 * get correct string for entry moderation status 
		 */		
		public static function getStatusForModeration(item:Object, column:DataGridColumn):String {
			var entry:BorhanBaseEntry = item as BorhanBaseEntry;
			var rm:IResourceManager = ResourceManager.getInstance();
			switch (entry.moderationStatus) {
				case BorhanEntryModerationStatus.APPROVED:  {
					return rm.getString('entrytable', 'approvedStatus');
				}
				case BorhanEntryModerationStatus.AUTO_APPROVED:  {
					return rm.getString('entrytable', 'autoApprovedStatus');
				}
				case BorhanEntryModerationStatus.FLAGGED_FOR_REVIEW:  {
					return rm.getString('entrytable', 'flaggedStatus');
				}
				case BorhanEntryModerationStatus.PENDING_MODERATION:  {
					return rm.getString('entrytable', 'pendingStatus');
				}
				case BorhanEntryModerationStatus.REJECTED:  {
					return rm.getString('entrytable', 'rejectedStatus');
				}
			}
			return '';
		}

		/**
		 * the function translate status type enum to the matching locale string
		 * @param obj	data object for the itemrenderer
		 */
		public static function getStatus(item:Object, column:DataGridColumn):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var entry:BorhanBaseEntry = item as BorhanBaseEntry;
			var status:String = entry.status;
			switch (status) {
				case BorhanEntryStatus.DELETED: 
					//fixed to all states
					return rm.getString('cms', 'statusdeleted');
					break;
				
				case BorhanEntryStatus.ERROR_IMPORTING: 
					//fixed to all states
					return rm.getString('cms', 'statuserrorimporting');
					break;
				
				case BorhanEntryStatus.ERROR_CONVERTING: 
					//fixed to all states
					return rm.getString('cms', 'statuserrorconverting');
					break;
				
				case BorhanEntryStatus.IMPORT: 
					//fixed to all states
					if (entry is BorhanLiveStreamEntry) {
						return rm.getString('cms', 'provisioning');
					}
					else {
						return rm.getString('cms', 'statusimport');
					}
					break;
				
				case BorhanEntryStatus.PRECONVERT: 
					//fixed to all states
					return rm.getString('cms', 'statuspreconvert');
					break;
				
				case BorhanEntryStatus.PENDING:
					return rm.getString('cms', 'statuspending');
					break;
				
				case BorhanEntryStatus.NO_CONTENT:  
					return rm.getString('cms', 'statusNoMedia');
					break;
				
				case BorhanEntryStatus.READY:  
					return getStatusForReadyEntry(entry);
					break;
				
			}
			return '';
		}
		
		
		private static const SCHEDULING_ALL_OR_IN_FRAME:int = 1;
		private static const SCHEDULING_BEFORE_FRAME:int = 2;
		private static const SCHEDULING_AFTER_FRAME:int = 3;
		
		/**
		 * the text for a ready entry is caculated according to moderation status / scheduling
		 * */
		private static function getStatusForReadyEntry(entry:BorhanBaseEntry):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			var result:String = '';
			var now:Date = new Date();
			var time:int = now.time / 1000;
			var schedulingType:int = 0;
			
			if (((entry.startDate == int.MIN_VALUE) && (entry.endDate == int.MIN_VALUE)) || ((entry.startDate <= time) && (entry.endDate >= time)) || ((entry.startDate < time) && (entry.endDate == int.MIN_VALUE)) || ((entry.startDate == int.MIN_VALUE) && (entry.endDate > time))) {
				schedulingType = SCHEDULING_ALL_OR_IN_FRAME;
			}
			else if (entry.startDate > time) {
				schedulingType = SCHEDULING_BEFORE_FRAME;
			}
			else if (entry.endDate < time) {
				schedulingType = SCHEDULING_AFTER_FRAME;
			}
			
			var moderationStatus:int = entry.moderationStatus;
			
			
			switch (moderationStatus) {
				case BorhanEntryModerationStatus.APPROVED:
				case BorhanEntryModerationStatus.AUTO_APPROVED:
				case BorhanEntryModerationStatus.FLAGGED_FOR_REVIEW:  
					if (schedulingType == SCHEDULING_ALL_OR_IN_FRAME){
						result = rm.getString('entrytable', 'liveStatus');
					}
					else if (schedulingType == SCHEDULING_BEFORE_FRAME) {
						result = rm.getString('entrytable', 'scheduledStatus');
					}
					else if (schedulingType == SCHEDULING_AFTER_FRAME) {
						result = rm.getString('entrytable', 'finishedStatus');
					}
					break;
				
				case BorhanEntryModerationStatus.PENDING_MODERATION:  
					result = rm.getString('entrytable', 'pendingStatus');
					break;
				
				case BorhanEntryModerationStatus.REJECTED:  
					result = rm.getString('entrytable', 'rejectedStatus');
					break;
				
			}
			
			
			return result;
		}
	}
}