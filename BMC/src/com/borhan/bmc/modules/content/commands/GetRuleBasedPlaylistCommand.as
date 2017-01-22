package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.events.RuleBasedTypeEvent;
	import com.borhan.commands.playlist.PlaylistExecuteFromFilters;
	import com.borhan.events.BorhanEvent;
	import com.borhan.utils.KTimeUtil;
	import com.borhan.vo.BorhanPlaylist;
	
	import mx.rpc.IResponder;
	import com.borhan.bmc.modules.content.events.BMCEntryEvent;

	public class GetRuleBasedPlaylistCommand extends BorhanCommand implements ICommand, IResponder
	{
		private var _currentPlaylist : BorhanPlaylist;
		
		override public function execute(event:CairngormEvent):void
		{	
			_model.increaseLoadCounter();
 			var e : BMCEntryEvent = event as BMCEntryEvent;
			_currentPlaylist = e.entryVo as BorhanPlaylist;
			if(_currentPlaylist.totalResults == int.MIN_VALUE)
				_currentPlaylist.totalResults = 50; // Ariel definition - up to 50 per playlist 
			var playlistGet:PlaylistExecuteFromFilters = new PlaylistExecuteFromFilters(_currentPlaylist.filters,_currentPlaylist.totalResults);
			playlistGet.addEventListener(BorhanEvent.COMPLETE, result);
			playlistGet.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(playlistGet);
		}
		
		override public function result(data:Object):void
		{
			super.result(data);
			_model.decreaseLoadCounter();
			//if this is a playlist - and not one rule - update duration and amount of entries
			if (_model.playlistModel.rulePlaylistType == RuleBasedTypeEvent.MULTY_RULES) {
				var totalDuration:Number = 0;
				var nEntries:uint;
				if (data.data is Array && (data.data as Array).length > 0) {
					var l:int = data.data.length; 
					for (nEntries=0; nEntries<l; nEntries++) {
						if(data.data[nEntries].hasOwnProperty("duration"))
							totalDuration += data.data[nEntries]["duration"];	
					}
				}
				_model.playlistModel.ruleBasedDuration = KTimeUtil.formatTime2(totalDuration);
				_model.playlistModel.ruleBasedEntriesAmount = nEntries;
			}
			
 			if(data.data is Array && _currentPlaylist.parts) {
				//TODO this is not a nice implementation :( 
				_currentPlaylist.parts.source = data.data;
				_currentPlaylist.parts = null;
				// sum all entries duration 
				_currentPlaylist = null;
			} 
		}
	}
}