package com.borhan.bmc.modules.content.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.borhan.bmc.modules.content.events.SetPlaylistTypeEvent;

	/**
	 * set the _model.playlistModel.onTheFlyPlaylistType 
	 * to manual, to rule based or to none
	 */
	public class SetPlaylistTypeCommand extends BorhanCommand
	{
		override public function execute(event:CairngormEvent):void
		{
			_model.playlistModel.onTheFlyPlaylistType = event.type;
			if (event.type == SetPlaylistTypeEvent.NONE_PLAYLIST) {
				_model.playlistModel.onTheFlyPlaylistEntries = null;
			}
		}
	}
}