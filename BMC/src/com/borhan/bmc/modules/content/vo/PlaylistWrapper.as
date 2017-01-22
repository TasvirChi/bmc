package com.borhan.bmc.modules.content.vo
{
	import com.borhan.vo.BorhanPlaylist;
	
	import mx.collections.ArrayCollection;
	
	public class PlaylistWrapper extends Object
	{
		
	[Bindable]
	public var playlist:BorhanPlaylist;
	[Bindable]
	public var parts:ArrayCollection;
	
		public function PlaylistWrapper(playlist:BorhanPlaylist= null,part:ArrayCollection = null) 
		{
			this.playlist=playlist;
			this.parts=part;
		}
	}
}