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
	import com.borhan.vo.BorhanJobData;

	[Bindable]
	public dynamic class BorhanConvertLiveSegmentJobData extends BorhanJobData
	{
		/**
		* Live stream entry id
		**/
		public var entryId : String = null;

		/**
		**/
		public var assetId : String = null;

		/**
		* Primary or secondary media server
		* @see com.borhan.types.BorhanEntryServerNodeType
		**/
		public var mediaServerIndex : String = null;

		/**
		* The index of the file within the entry
		**/
		public var fileIndex : int = int.MIN_VALUE;

		/**
		* The recorded live media
		**/
		public var srcFilePath : String = null;

		/**
		* The output file
		**/
		public var destFilePath : String = null;

		/**
		* Duration of the live entry including all recorded segments including the current
		**/
		public var endTime : Number = Number.NEGATIVE_INFINITY;

		/**
		* The data output file
		**/
		public var destDataFilePath : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('assetId');
			arr.push('mediaServerIndex');
			arr.push('fileIndex');
			arr.push('srcFilePath');
			arr.push('destFilePath');
			arr.push('endTime');
			arr.push('destDataFilePath');
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
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
