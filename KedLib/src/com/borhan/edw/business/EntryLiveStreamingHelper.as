package com.borhan.edw.business
{
	import com.borhan.types.BorhanDVRStatus;
	import com.borhan.types.BorhanRecordStatus;
	import com.borhan.utils.KTimeUtil;
	import com.borhan.vo.BorhanLiveStreamEntry;
	
	import mx.resources.ResourceManager;

	public class EntryLiveStreamingHelper
	{
		
		public static const PREFIXES_WIDTH:Number = 130;
		public static const BROADCASTING_WIDTH:Number = 500;
		
		public function EntryLiveStreamingHelper()
		{
		}
		
		public static function getDVRStatus (entry:BorhanLiveStreamEntry):String {
			var result:String = '';
			if (!entry.dvrStatus || entry.dvrStatus == BorhanDVRStatus.DISABLED) {
				result = ResourceManager.getInstance().getString('drilldown', 'off');
			}
			else if (entry.dvrStatus == BorhanDVRStatus.ENABLED) {
				result = ResourceManager.getInstance().getString('drilldown', 'on');
			}
			return result;
		}
		
		public static function getDVRWindow (entry:BorhanLiveStreamEntry):String {
			return ResourceManager.getInstance().getString('drilldown', 'dvrWinFormat', [KTimeUtil.formatTime2(entry.dvrWindow*60, true, false, true)]);
		}
		
		public static function getRecordStatus (entry:BorhanLiveStreamEntry):String {
			var result:String = '';
			if (!entry.recordStatus || entry.recordStatus == BorhanRecordStatus.DISABLED) {
				result = ResourceManager.getInstance().getString('drilldown', 'off');
			}
			else if (entry.recordStatus == BorhanRecordStatus.APPENDED || entry.recordStatus == BorhanRecordStatus.PER_SESSION) {
				result = ResourceManager.getInstance().getString('drilldown', 'on');
			}
			return result;
		}
		
		
	}
}