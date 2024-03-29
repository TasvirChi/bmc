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
	import com.borhan.vo.BorhanDistributionProvider;

	[Bindable]
	public dynamic class BorhanGenericDistributionProvider extends BorhanDistributionProvider
	{
		/**
		* Auto generated
		**/
		public var id : int = int.MIN_VALUE;

		/**
		* Generic distribution provider creation date as Unix timestamp (In seconds)
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* Generic distribution provider last update date as Unix timestamp (In seconds)
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* @see com.borhan.types.borhanBoolean
		**/
		public var isDefault : Boolean;

		/**
		* @see com.borhan.types.BorhanGenericDistributionProviderStatus
		**/
		public var status : int = int.MIN_VALUE;

		/**
		**/
		public var optionalFlavorParamsIds : String = null;

		/**
		**/
		public var requiredFlavorParamsIds : String = null;

		/**
		**/
		public var optionalThumbDimensions : Array = null;

		/**
		**/
		public var requiredThumbDimensions : Array = null;

		/**
		**/
		public var editableFields : String = null;

		/**
		**/
		public var mandatoryFields : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isDefault');
			arr.push('optionalFlavorParamsIds');
			arr.push('requiredFlavorParamsIds');
			arr.push('optionalThumbDimensions');
			arr.push('requiredThumbDimensions');
			arr.push('editableFields');
			arr.push('mandatoryFields');
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
				case 'optionalThumbDimensions':
					result = 'BorhanDistributionThumbDimensions';
					break;
				case 'requiredThumbDimensions':
					result = 'BorhanDistributionThumbDimensions';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
