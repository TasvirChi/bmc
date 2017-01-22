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
	import com.borhan.vo.BorhanIntegrationJobTriggerData;

	import com.borhan.vo.BorhanIntegrationJobProviderData;

	import com.borhan.vo.BorhanJobData;

	[Bindable]
	public dynamic class BorhanIntegrationJobData extends BorhanJobData
	{
		/**
		**/
		public var callbackNotificationUrl : String = null;

		/**
		* @see com.borhan.types.BorhanIntegrationProviderType
		**/
		public var providerType : String = null;

		/**
		* Additional data that relevant for the provider only
		**/
		public var providerData : BorhanIntegrationJobProviderData;

		/**
		* @see com.borhan.types.BorhanIntegrationTriggerType
		**/
		public var triggerType : String = null;

		/**
		* Additional data that relevant for the trigger only
		**/
		public var triggerData : BorhanIntegrationJobTriggerData;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('providerType');
			arr.push('providerData');
			arr.push('triggerType');
			arr.push('triggerData');
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
				case 'providerData':
					result = '';
					break;
				case 'triggerData':
					result = '';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
