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
	public dynamic class BorhanCategory extends BaseFlexVo
	{
		/**
		* The id of the Category
		**/
		public var id : int = int.MIN_VALUE;

		/**
		**/
		public var parentId : int = int.MIN_VALUE;

		/**
		**/
		public var depth : int = int.MIN_VALUE;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		* The name of the Category.
		* The following characters are not allowed: '<', '>', ','
		**/
		public var name : String = null;

		/**
		* The full name of the Category
		**/
		public var fullName : String = null;

		/**
		* The full ids of the Category
		**/
		public var fullIds : String = null;

		/**
		* Number of entries in this Category (including child categories)
		**/
		public var entriesCount : int = int.MIN_VALUE;

		/**
		* Creation date as Unix timestamp (In seconds)
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* Update date as Unix timestamp (In seconds)
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		* Category description
		**/
		public var description : String = null;

		/**
		* Category tags
		**/
		public var tags : String = null;

		/**
		* If category will be returned for list action.
		* @see com.borhan.types.BorhanAppearInListType
		**/
		public var appearInList : int = int.MIN_VALUE;

		/**
		* defines the privacy of the entries that assigned to this category
		* @see com.borhan.types.BorhanPrivacyType
		**/
		public var privacy : int = int.MIN_VALUE;

		/**
		* If Category members are inherited from parent category or set manualy.
		* @see com.borhan.types.BorhanInheritanceType
		**/
		public var inheritanceType : int = int.MIN_VALUE;

		/**
		* Who can ask to join this category
		* @see com.borhan.types.BorhanUserJoinPolicyType
		**/
		public var userJoinPolicy : int = int.MIN_VALUE;

		/**
		* Default permissionLevel for new users
		* @see com.borhan.types.BorhanCategoryUserPermissionLevel
		**/
		public var defaultPermissionLevel : int = int.MIN_VALUE;

		/**
		* Category Owner (User id)
		**/
		public var owner : String = null;

		/**
		* Number of entries that belong to this category directly
		**/
		public var directEntriesCount : int = int.MIN_VALUE;

		/**
		* Category external id, controlled and managed by the partner.
		**/
		public var referenceId : String = null;

		/**
		* who can assign entries to this category
		* @see com.borhan.types.BorhanContributionPolicyType
		**/
		public var contributionPolicy : int = int.MIN_VALUE;

		/**
		* Number of active members for this category
		**/
		public var membersCount : int = int.MIN_VALUE;

		/**
		* Number of pending members for this category
		**/
		public var pendingMembersCount : int = int.MIN_VALUE;

		/**
		* Set privacy context for search entries that assiged to private and public categories. the entries will be private if the search context is set with those categories.
		**/
		public var privacyContext : String = null;

		/**
		* comma separated parents that defines a privacyContext for search
		**/
		public var privacyContexts : String = null;

		/**
		* Status
		* @see com.borhan.types.BorhanCategoryStatus
		**/
		public var status : int = int.MIN_VALUE;

		/**
		* The category id that this category inherit its members and members permission (for contribution and join)
		**/
		public var inheritedParentId : int = int.MIN_VALUE;

		/**
		* Can be used to store various partner related data as a numeric value
		**/
		public var partnerSortValue : int = int.MIN_VALUE;

		/**
		* Can be used to store various partner related data as a string
		**/
		public var partnerData : String = null;

		/**
		* Enable client side applications to define how to sort the category child categories
		* @see com.borhan.types.BorhanCategoryOrderBy
		**/
		public var defaultOrderBy : String = null;

		/**
		* Number of direct children categories
		**/
		public var directSubCategoriesCount : int = int.MIN_VALUE;

		/**
		* Moderation to add entries to this category by users that are not of permission level Manager or Moderator.
		* @see com.borhan.types.BorhanNullableBoolean
		**/
		public var moderation : int = int.MIN_VALUE;

		/**
		* Nunber of pending moderation entries
		**/
		public var pendingEntriesCount : int = int.MIN_VALUE;

		/**
		* Flag indicating that the category is an aggregation category
		* @see com.borhan.types.BorhanNullableBoolean
		**/
		public var isAggregationCategory : int = int.MIN_VALUE;

		/**
		* List of aggregation channels the category belongs to
		**/
		public var aggregationCategories : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('parentId');
			arr.push('name');
			arr.push('description');
			arr.push('tags');
			arr.push('appearInList');
			arr.push('privacy');
			arr.push('inheritanceType');
			arr.push('defaultPermissionLevel');
			arr.push('owner');
			arr.push('referenceId');
			arr.push('contributionPolicy');
			arr.push('privacyContext');
			arr.push('partnerSortValue');
			arr.push('partnerData');
			arr.push('defaultOrderBy');
			arr.push('moderation');
			arr.push('isAggregationCategory');
			arr.push('aggregationCategories');
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
			}
			return result;
		}
	}
}
