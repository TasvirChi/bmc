package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.playlist.PlaylistExecute;
	import com.borhan.edw.control.events.KedEntryEvent;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.BMCEntryEvent;
	import com.borhan.vo.BorhanPlaylist;

	public class GetPlaylistCommand extends BorhanCommand {
		private var _currentPlaylist:BorhanPlaylist;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var e:BMCEntryEvent = event as BMCEntryEvent;
			_currentPlaylist = e.entryVo as BorhanPlaylist;
			var playlistGet:PlaylistExecute = new PlaylistExecute(_currentPlaylist.id);
			playlistGet.addEventListener(BorhanEvent.COMPLETE, result);
			playlistGet.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(playlistGet);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (data.data is Array) {
				//this is not a nice implementation :( todo - fix this
				_currentPlaylist.parts.source = data.data;
				_currentPlaylist.parts = null;
			}
		}
	}
}