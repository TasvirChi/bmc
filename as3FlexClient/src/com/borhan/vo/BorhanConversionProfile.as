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
	import com.borhan.vo.BorhanCropDimensions;

	import com.borhan.vo.BaseFlexVo;

	[Bindable]
	public dynamic class BorhanConversionProfile extends BaseFlexVo
	{
		/**
		* The id of the Conversion Profile
		**/
		public var id : int = int.MIN_VALUE;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* @see com.borhan.types.BorhanConversionProfileStatus
		**/
		public var status : String = null;

		/**
		* @see com.borhan.types.BorhanConversionProfileType
		**/
		public var type : String = null;

		/**
		* The name of the Conversion Profile
		**/
		public var name : String = null;

		/**
		* System name of the Conversion Profile
		**/
		public var systemName : String = null;

		/**
		* Comma separated tags
		**/
		public var tags : String = null;

		/**
		* The description of the Conversion Profile
		**/
		public var description : String = null;

		/**
		* ID of the default entry to be used for template data
		**/
		public var defaultEntryId : String = null;

		/**
		* Creation date as Unix timestamp (In seconds)
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* List of included flavor ids (comma separated)
		**/
		public var flavorParamsIds : String = null;

		/**
		* Indicates that this conversion profile is system default
		* @see com.borhan.types.BorhanNullableBoolean
		**/
		public var isDefault : int = int.MIN_VALUE;

		/**
		* Indicates that this conversion profile is partner default
		* @see com.borhan.types.borhanBoolean
		**/
		public var isPartnerDefault : Boolean;

		/**
		* Cropping dimensions
		**/
		public var cropDimensions : BorhanCropDimensions;

		/**
		* Clipping start position (in miliseconds)
		**/
		public var clipStart : int = int.MIN_VALUE;

		/**
		* Clipping duration (in miliseconds)
		**/
		public var clipDuration : int = int.MIN_VALUE;

		/**
		* XSL to transform ingestion MRSS XML
		**/
		public var xslTransformation : String = null;

		/**
		* ID of default storage profile to be used for linked net-storage file syncs
		**/
		public var storageProfileId : int = int.MIN_VALUE;

		/**
		* Media parser type to be used for extract media
		* @see com.borhan.types.BorhanMediaParserType
		**/
		public var mediaParserType : String = null;

		/**
		* Should calculate file conversion complexity
		* @see com.borhan.types.BorhanNullableBoolean
		**/
		public var calculateComplexity : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('status');
			arr.push('name');
			arr.push('systemName');
			arr.push('tags');
			arr.push('description');
			arr.push('defaultEntryId');
			arr.push('flavorParamsIds');
			arr.push('isDefault');
			arr.push('cropDimensions');
			arr.push('clipStart');
			arr.push('clipDuration');
			arr.push('xslTransformation');
			arr.push('storageProfileId');
			arr.push('mediaParserType');
			arr.push('calculateComplexity');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			return arr;
		}

		/** 
		* get the expected type of array elements 
		* @param arrayName 	 name of an attribute of type array of the current object 
		* @return 	 un-qualified class name 
		**/ 
		public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'cropDimensions':
					result = '';
					break;
			}
			return result;
		}
	}
}
