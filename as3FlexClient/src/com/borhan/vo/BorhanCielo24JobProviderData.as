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
	import com.borhan.vo.BorhanIntegrationJobProviderData;

	[Bindable]
	public dynamic class BorhanCielo24JobProviderData extends BorhanIntegrationJobProviderData
	{
		/**
		* Entry ID
		**/
		public var entryId : String = null;

		/**
		* Flavor ID
		**/
		public var flavorAssetId : String = null;

		/**
		* Caption formats
		**/
		public var captionAssetFormats : String = null;

		/**
		* @see com.borhan.types.BorhanCielo24Priority
		**/
		public var priority : String = null;

		/**
		* @see com.borhan.types.BorhanCielo24Fidelity
		**/
		public var fidelity : String = null;

		/**
		* Api key for service provider
		**/
		public var username : String = null;

		/**
		* Api key for service provider
		**/
		public var password : String = null;

		/**
		* Base url for service provider
		**/
		public var baseUrl : String = null;

		/**
		* Transcript content language
		* @see com.borhan.types.BorhanLanguage
		**/
		public var spokenLanguage : String = null;

		/**
		* should replace remote media content
		* @see com.borhan.types.borhanBoolean
		**/
		public var replaceMediaContent : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryId');
			arr.push('flavorAssetId');
			arr.push('captionAssetFormats');
			arr.push('priority');
			arr.push('fidelity');
			arr.push('spokenLanguage');
			arr.push('replaceMediaContent');
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
