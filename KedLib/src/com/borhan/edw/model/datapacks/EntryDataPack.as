package com.borhan.edw.model.datapacks
{
	import com.borhan.bmvc.model.IDataPack;
	import com.borhan.types.BorhanNullableBoolean;
	import com.borhan.vo.BorhanBaseEntry;
	import com.borhan.vo.BorhanUser;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * information regarding the current entry, its replacement, etc
	 * */
	public class EntryDataPack implements IDataPack {
		
		/**
		 * max number of categories an entry may be associated with by default
		 * */
		public static const DEFAULT_CATEGORIES_NUM:int = 32;
		
		/**
		 * max number of categories an entry may be associated with if FEATURE_DISABLE_CATEGORY_LIMIT is on
		 * */
		public static const MANY_CATEGORIES_NUM:int = 200;
		
		
		public var shared:Boolean = false;
		
		/**
		 * the max number of categories to which an entry may be assigned 
		 */		
		public var maxNumCategories:int = MANY_CATEGORIES_NUM;
		
		/**
		 * list of Object {label}	<br>
		 * used for entry details window > entry metadata (autocomplete DP)
		 * */
		public var categoriesFullNameList:ArrayCollection = new ArrayCollection();
		
		/**
		 * Current Viewed Entry
		 */
		public var selectedEntry:BorhanBaseEntry;
		
		/**
		 * index of Current Viewed Entry
		 */
		public var selectedIndex:int;
		
		/**
		 * replacement entry of the selected entry 
		 */		
		public var selectedReplacementEntry:BorhanBaseEntry;
		
		
		/**
		 * Name of the replaced entry for the replacement entry
		 * */
		public var replacedEntryName:String;
		
		/**
		 * if selected entry was refreshed
		 * */
		public var selectedEntryReloaded:Boolean;
		
		/**
		 * if selected entry is a borhan livestream entry, is it currently boradcasting HDS?
		 * (use Nullable so we can set "no value" and binding will fire)
		 */
		public var selectedLiveEntryIsLive:int = BorhanNullableBoolean.NULL_VALUE;
		
		/**
		 * when saving an entry we list all entries that have the same 
		 * referenceId as the entry being saved. this is the list.
		 */
		public var entriesWSameRefidAsSelected:Array;
		
		public var loadRoughcuts:Boolean = true;
		
		
		/**
		 * list of categories the current entry is associated with
		 */
		public var entryCategories:ArrayCollection;
		
		
		/**
		 * the owner of the selected entry
		 */		
		public var selectedEntryOwner:BorhanUser;
		
		/**
		 * the creator of the selected entry
		 */		
		public var selectedEntryCreator:BorhanUser;
		
		/**
		 * the editors of the selected entry
		 * [BorhanUser]
		 */		
		public var entryEditors:Array;
		
		/**
		 * the publishers of the selected entry
		 * [BorhanUser]
		 */		
		public var entryPublishers:Array;
	}
}