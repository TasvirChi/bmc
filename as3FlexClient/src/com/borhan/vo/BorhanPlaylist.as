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
package com.borhan.vo
{
	import com.borhan.vo.BorhanBaseEntry;

	[Bindable]
	public dynamic class BorhanPlaylist extends BorhanBaseEntry
	{
		/**
		* Content of the playlist -
		* XML if the playlistType is dynamic
		* text if the playlistType is static
		* url if the playlistType is mRss
		**/
		public var playlistContent : String = null;

		/**
		**/
		public var filters : Array = null;

		/**
		* Maximum count of results to be returned in playlist execution
		**/
		public var totalResults : int = int.MIN_VALUE;

		/**
		* Type of playlist
		* @see com.borhan.types.BorhanPlaylistType
		**/
		public var playlistType : int = int.MIN_VALUE;

		/**
		* Number of plays
		**/
		public var plays : int = int.MIN_VALUE;

		/**
		* Number of views
		**/
		public var views : int = int.MIN_VALUE;

		/**
		* The duration in seconds
		**/
		public var duration : int = int.MIN_VALUE;

		/**
		* The url for this playlist
		**/
		public var executeUrl : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('playlistContent');
			arr.push('filters');
			arr.push('totalResults');
			arr.push('playlistType');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'filters':
					result = 'BorhanMediaEntryFilterForPlaylist';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
