package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.analytics.GoogleAnalyticsConsts;
	import com.borhan.analytics.GoogleAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTracker;
	import com.borhan.analytics.KAnalyticsTrackerConsts;
	import com.borhan.commands.playlist.PlaylistAdd;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.BMCSearchEvent;
	import com.borhan.bmc.modules.content.events.WindowEvent;
	import com.borhan.types.BorhanPlaylistType;
	import com.borhan.types.BorhanStatsBmcEventType;
	import com.borhan.utils.SoManager;
	import com.borhan.vo.BorhanPlaylist;
	import com.borhan.vo.BorhanPlaylistFilter;
	import com.borhan.bmc.modules.content.events.BMCEntryEvent;

	public class AddEntryCommand extends BorhanCommand {
		private var _playListType:Number;


		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			var e:BMCEntryEvent = event as BMCEntryEvent;
			var addplaylist:PlaylistAdd = new PlaylistAdd(e.entryVo as BorhanPlaylist);
			addplaylist.addEventListener(BorhanEvent.COMPLETE, result);
			addplaylist.addEventListener(BorhanEvent.FAILED, fault);
			_model.context.kc.post(addplaylist);
			_playListType = e.entryVo.playlistType;
			//first time funnel
			if (!SoManager.getInstance().checkOrFlush(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYLIST_CREATION))
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_FIRST_TIME_PLAYLIST_CREATION, GoogleAnalyticsConsts.CONTENT);
		}


		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (_model.listableVo.filterVo is BorhanPlaylistFilter) {
				var searchEvent:BMCSearchEvent = new BMCSearchEvent(BMCSearchEvent.SEARCH_PLAYLIST, _model.listableVo);
				searchEvent.dispatch();
			}
			var cgEvent:WindowEvent = new WindowEvent(WindowEvent.CLOSE);
			cgEvent.dispatch();

			if (_playListType == BorhanPlaylistType.DYNAMIC) {
				KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT, BorhanStatsBmcEventType.CONTENT_ADD_PLAYLIST, "RuleBasedPlayList>AddPlayList" + ">" + data.data.id);
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_ADD_RULEBASED_PLAYLIST, GoogleAnalyticsConsts.CONTENT);
			}
			else if (_playListType == BorhanPlaylistType.STATIC_LIST) {
				KAnalyticsTracker.getInstance().sendEvent(KAnalyticsTrackerConsts.CONTENT, BorhanStatsBmcEventType.CONTENT_ADD_PLAYLIST, "ManuallPlayList>AddPlayList" + ">" + data.data.id);
				GoogleAnalyticsTracker.getInstance().sendToGA(GoogleAnalyticsConsts.CONTENT_ADD_PLAYLIST, GoogleAnalyticsConsts.CONTENT);
			}

		}
	}
}