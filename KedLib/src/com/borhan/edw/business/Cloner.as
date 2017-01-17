package com.borhan.edw.business
{
	import com.borhan.utils.ObjectUtil;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanLiveStreamAdminEntry;
	import com.borhan.vo.BorhanLiveStreamEntry;
	import com.borhan.vo.BorhanMediaEntry;
	import com.borhan.vo.BorhanMixEntry;
	import com.borhan.vo.BorhanPlayableEntry;
	import com.borhan.vo.BorhanPlaylist;
	
	public class Cloner
	{
		public function Cloner()
		{
		}
		
		/**
		 * clone according to entry type
		 * */
		public static function cloneByEntryType(entry:BorhanBaseEntry):BorhanBaseEntry {
			var copy:BorhanBaseEntry;
			
			if (entry is BorhanPlaylist) {
				copy = cloneBorhanPlaylist(entry as BorhanPlaylist);
			}
			else if (entry is BorhanMixEntry) {
				copy = cloneBorhanMixEntry(entry as BorhanMixEntry);
			}
			else if (entry is BorhanLiveStreamEntry || entry is BorhanLiveStreamAdminEntry) {
				copy = cloneBorhanStreamAdminEntry(entry as BorhanLiveStreamEntry);
			}
			else if (entry is BorhanMediaEntry) {
				copy = cloneBorhanMediaEntry(entry as BorhanMediaEntry);
			}
			return copy;
		}
		
		
		/**
		 * Return a new BorhanBaseEntry object with same attributes as source attributes
		 */
		public static function cloneBorhanBaseEntry(source:BorhanBaseEntry):BorhanBaseEntry
		{
			var be:BorhanBaseEntry = new BorhanBaseEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				be[atts[i]] = source[atts[i]];
			} 
			
			return be;
		}
		
		/**
		 * Return a new BorhanPlayableEntry object with same attributes as source attributes
		 */
		public static function cloneBorhanPlayableEntry(source:BorhanPlayableEntry):BorhanPlayableEntry
		{
			var kpe:BorhanPlayableEntry = new BorhanPlayableEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				kpe[atts[i]] = source[atts[i]];
			} 
			return kpe;
		}
		
		
		/**
		 * Return a new BorhanMediaEntry object with same attributes as source attributes
		 */
		public static function cloneBorhanMediaEntry(source:BorhanMediaEntry):BorhanMediaEntry
		{
			var me:BorhanMediaEntry = new BorhanMediaEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				me[atts[i]] = source[atts[i]];
			} 
			return me;
		}

		/**
		 * Return a new BorhanPlaylist object with same attributes as source attributes
		 */
		public static function cloneBorhanPlaylist(source:BorhanPlaylist):BorhanPlaylist
		{
			var pl:BorhanPlaylist = new BorhanPlaylist();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				pl[atts[i]] = source[atts[i]];
			} 
			return pl;
		}
		/**
		 * Return a new BorhanMixEntry object with same attributes as source attributes
		 */
		public static function cloneBorhanMixEntry(source:BorhanMixEntry):BorhanMixEntry
		{
			var mix:BorhanMixEntry = new BorhanMixEntry();
			
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				mix[atts[i]] = source[atts[i]];
			} 
			
			return mix;
		}
		
		public static function cloneBorhanStreamAdminEntry(source:BorhanLiveStreamEntry):BorhanLiveStreamEntry
		{
			var klsae:BorhanLiveStreamEntry = new BorhanLiveStreamEntry();
			var atts:Array = ObjectUtil.getObjectAllKeys(source);
			for (var i:int = 0; i< atts.length; i++) {
				klsae[atts[i]] = source[atts[i]];
			} 
			
			return klsae
		}
	}
}