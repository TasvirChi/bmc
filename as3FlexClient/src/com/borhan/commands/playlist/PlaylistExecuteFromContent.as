// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Borhan Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2016  Borhan Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.borhan.commands.playlist
{
		import com.borhan.vo.BorhanFilterPager;
	import com.borhan.delegates.playlist.PlaylistExecuteFromContentDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* Retrieve playlist for playing purpose, based on content
	**/
	public class PlaylistExecuteFromContent extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param playlistType int
		* @param playlistContent String
		* @param detailed String
		* @param pager BorhanFilterPager
		**/
		public function PlaylistExecuteFromContent( playlistType : int,playlistContent : String,detailed : String='',pager : BorhanFilterPager=null )
		{
			service= 'playlist';
			action= 'executeFromContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('playlistType');
			valueArr.push(playlistType);
			keyArr.push('playlistContent');
			valueArr.push(playlistContent);
			keyArr.push('detailed');
			valueArr.push(detailed);
			if (pager) { 
				keyValArr = borhanObject2Arrays(pager, 'pager');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistExecuteFromContentDelegate( this , config );
		}
	}
}
