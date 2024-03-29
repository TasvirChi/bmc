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
	import com.borhan.vo.BorhanMatchCondition;

	[Bindable]
	public dynamic class BorhanMetadataFieldChangedCondition extends BorhanMatchCondition
	{
		/**
		* May contain the full xpath to the field in three formats
		* 1. Slashed xPath, e.g. /metadata/myElementName
		* 2. Using local-name function, e.g. /[local-name()='metadata']/[local-name()='myElementName']
		* 3. Using only the field name, e.g. myElementName, it will be searched as //myElementName
		**/
		public var xPath : String = null;

		/**
		* Metadata profile id
		**/
		public var profileId : int = int.MIN_VALUE;

		/**
		* Metadata profile system name
		**/
		public var profileSystemName : String = null;

		/**
		**/
		public var versionA : String = null;

		/**
		**/
		public var versionB : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('xPath');
			arr.push('profileId');
			arr.push('profileSystemName');
			arr.push('versionA');
			arr.push('versionB');
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
