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
	import com.borhan.vo.BorhanRelatedFilter;

	[Bindable]
	public dynamic class BorhanUserBaseFilter extends BorhanRelatedFilter
	{
		/**
		**/
		public var partnerIdEqual : int = int.MIN_VALUE;

		/**
		* @see com.borhan.types.BorhanUserType
		**/
		public var typeEqual : int = int.MIN_VALUE;

		/**
		**/
		public var typeIn : String = null;

		/**
		**/
		public var screenNameLike : String = null;

		/**
		**/
		public var screenNameStartsWith : String = null;

		/**
		**/
		public var emailLike : String = null;

		/**
		**/
		public var emailStartsWith : String = null;

		/**
		**/
		public var tagsMultiLikeOr : String = null;

		/**
		**/
		public var tagsMultiLikeAnd : String = null;

		/**
		* @see com.borhan.types.BorhanUserStatus
		**/
		public var statusEqual : int = int.MIN_VALUE;

		/**
		**/
		public var statusIn : String = null;

		/**
		**/
		public var createdAtGreaterThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var createdAtLessThanOrEqual : int = int.MIN_VALUE;

		/**
		**/
		public var firstNameStartsWith : String = null;

		/**
		**/
		public var lastNameStartsWith : String = null;

		/**
		* @see com.borhan.types.BorhanNullableBoolean
		**/
		public var isAdminEqual : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('partnerIdEqual');
			arr.push('typeEqual');
			arr.push('typeIn');
			arr.push('screenNameLike');
			arr.push('screenNameStartsWith');
			arr.push('emailLike');
			arr.push('emailStartsWith');
			arr.push('tagsMultiLikeOr');
			arr.push('tagsMultiLikeAnd');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('createdAtGreaterThanOrEqual');
			arr.push('createdAtLessThanOrEqual');
			arr.push('firstNameStartsWith');
			arr.push('lastNameStartsWith');
			arr.push('isAdminEqual');
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
