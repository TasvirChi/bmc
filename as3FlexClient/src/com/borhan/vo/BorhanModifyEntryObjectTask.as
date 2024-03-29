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
	import com.borhan.vo.BorhanObjectTask;

	[Bindable]
	public dynamic class BorhanModifyEntryObjectTask extends BorhanObjectTask
	{
		/**
		* The input metadata profile id
		**/
		public var inputMetadataProfileId : int = int.MIN_VALUE;

		/**
		* array of {input metadata xpath location,entry field} objects
		**/
		public var inputMetadata : Array = null;

		/**
		* The output metadata profile id
		**/
		public var outputMetadataProfileId : int = int.MIN_VALUE;

		/**
		* array of {output metadata xpath location,entry field} objects
		**/
		public var outputMetadata : Array = null;

		/**
		* The input user id to set on the entry
		**/
		public var inputUserId : String = null;

		/**
		* The input entitled users edit to set on the entry
		**/
		public var inputEntitledUsersEdit : String = null;

		/**
		* The input entitled users publish to set on the entry
		**/
		public var inputEntitledUsersPublish : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('inputMetadataProfileId');
			arr.push('inputMetadata');
			arr.push('outputMetadataProfileId');
			arr.push('outputMetadata');
			arr.push('inputUserId');
			arr.push('inputEntitledUsersEdit');
			arr.push('inputEntitledUsersPublish');
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
				case 'inputMetadata':
					result = 'BorhanKeyValue';
					break;
				case 'outputMetadata':
					result = 'BorhanKeyValue';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
