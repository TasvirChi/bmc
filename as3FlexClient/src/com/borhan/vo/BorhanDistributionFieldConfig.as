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
	import com.borhan.vo.BaseFlexVo;

	[Bindable]
	public dynamic class BorhanDistributionFieldConfig extends BaseFlexVo
	{
		/**
		* A value taken from a connector field enum which associates the current configuration to that connector field
		* Field enum class should be returned by the provider's getFieldEnumClass function.
		**/
		public var fieldName : String = null;

		/**
		* A string that will be shown to the user as the field name in error messages related to the current field
		**/
		public var userFriendlyFieldName : String = null;

		/**
		* An XSLT string that extracts the right value from the Borhan entry MRSS XML.
		* The value of the current connector field will be the one that is returned from transforming the Borhan entry MRSS XML using this XSLT string.
		**/
		public var entryMrssXslt : String = null;

		/**
		* Is the field required to have a value for submission ?
		* @see com.borhan.types.BorhanDistributionFieldRequiredStatus
		**/
		public var isRequired : int = int.MIN_VALUE;

		/**
		* Trigger distribution update when this field changes or not ?
		* @see com.borhan.types.borhanBoolean
		**/
		public var updateOnChange : Boolean;

		/**
		* Entry column or metadata xpath that should trigger an update
		**/
		public var updateParams : Array = null;

		/**
		* Is this field config is the default for the distribution provider?
		* @see com.borhan.types.borhanBoolean
		**/
		public var isDefault : Boolean;

		/**
		* Is an error on this field going to trigger deletion of distributed content?
		* @see com.borhan.types.borhanBoolean
		**/
		public var triggerDeleteOnError : Boolean;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fieldName');
			arr.push('userFriendlyFieldName');
			arr.push('entryMrssXslt');
			arr.push('isRequired');
			arr.push('updateOnChange');
			arr.push('updateParams');
			arr.push('triggerDeleteOnError');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
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
				case 'updateParams':
					result = 'BorhanString';
					break;
			}
			return result;
		}
	}
}
