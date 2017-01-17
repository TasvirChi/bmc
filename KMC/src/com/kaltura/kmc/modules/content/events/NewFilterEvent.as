package com.borhan.bmc.modules.content.events
{
	import com.borhan.vo.BorhanMediaEntryFilterForPlaylist;
	
	import flash.events.Event;

	public class NewFilterEvent extends Event
	{
		static public const NEW_PLAYLIST_FILTER:String = "content_newPlaylistFilter";
		static public const EMPTY_PLAYLIST_FILTER:String = "content_emptyPlaylistFilter";
		
		private var _ruleVo:BorhanMediaEntryFilterForPlaylist;
		
		public function NewFilterEvent(type:String,playlistFilterVo:BorhanMediaEntryFilterForPlaylist, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_ruleVo = playlistFilterVo;
		}
		
		public function get ruleVo():BorhanMediaEntryFilterForPlaylist
		{
			return _ruleVo;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function clone():Event {
			return new NewFilterEvent(type, _ruleVo, bubbles, cancelable);
		}

	}
}