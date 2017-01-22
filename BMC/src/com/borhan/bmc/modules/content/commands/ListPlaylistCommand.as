package com.borhan.bmc.modules.content.commands {
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.commands.playlist.PlaylistList;
	import com.borhan.edw.control.events.SearchEvent;
	import com.borhan.edw.vo.ListableVo;
	import com.borhan.events.BorhanEvent;
	import com.borhan.bmc.modules.content.events.BMCSearchEvent;
	import com.borhan.types.BorhanPlaylistOrderBy;
	import com.borhan.vo.BorhanFilterPager;
	import com.borhan.vo.BorhanMediaEntryFilterForPlaylist;
	import com.borhan.vo.BorhanPlaylist;
	import com.borhan.vo.BorhanPlaylistFilter;
	import com.borhan.vo.BorhanPlaylistListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class ListPlaylistCommand extends BorhanCommand implements ICommand, IResponder {
		// Atar: I have no idea why we need this.
		BorhanMediaEntryFilterForPlaylist;

		/**
		 * External Syndication windows don't send a listableVO, playlist panel does. 
		 */		
		private var _caller:ListableVo;


		/**
		 * @inheritDoc
		 * */
		override public function execute(event:CairngormEvent):void {
			_model.increaseLoadCounter();
			_caller = (event as BMCSearchEvent).listableVo;

			if (_caller == null) {
				var pf:BorhanPlaylistFilter = new BorhanPlaylistFilter();
				pf.orderBy = BorhanPlaylistOrderBy.CREATED_AT_DESC;
				var pg:BorhanFilterPager = new BorhanFilterPager();
				pg.pageSize = 500;
				var generalPlaylistList:PlaylistList = new PlaylistList(pf, pg);
				generalPlaylistList.addEventListener(BorhanEvent.COMPLETE, result);
				generalPlaylistList.addEventListener(BorhanEvent.FAILED, fault);
				_model.context.kc.post(generalPlaylistList);
			}
			else {
				var kpf:BorhanPlaylistFilter = BorhanPlaylistFilter(_caller.filterVo);
				var playlistList:PlaylistList = new PlaylistList(kpf as BorhanPlaylistFilter,
																 _caller.pagingComponent.borhanFilterPager);
				playlistList.addEventListener(BorhanEvent.COMPLETE, result);
				playlistList.addEventListener(BorhanEvent.FAILED, fault);
				_model.context.kc.post(playlistList);
			}
		}


		/**
		 * @inheritDoc
		 * */
		override public function result(data:Object):void {
			super.result(data);
			_model.decreaseLoadCounter();
			if (_caller == null) {
				// from ext.syn subtab
				var tempArr:ArrayCollection = new ArrayCollection();
				var playlistListResult:BorhanPlaylistListResponse = data.data as BorhanPlaylistListResponse;
				for each (var playList:BorhanPlaylist in playlistListResult.objects) {
					tempArr.addItem(playList);
				}
				_model.extSynModel.generalPlayListdata = tempArr;
			}
			else {
				// from playlists subtab
				_caller.arrayCollection = new ArrayCollection(data.data.objects);
				_caller.pagingComponent.totalCount = data.data.totalCount;

				_caller = null;
			}
		}
	}
}