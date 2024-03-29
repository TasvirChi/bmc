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
package com.borhan.commands.doubleClick
{
	import com.borhan.delegates.doubleClick.DoubleClickGetFeedByEntryIdDelegate;
	import com.borhan.net.BorhanCall;

	/**
	**/
	public class DoubleClickGetFeedByEntryId extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param distributionProfileId int
		* @param hash String
		* @param entryId String
		**/
		public function DoubleClickGetFeedByEntryId( distributionProfileId : int,hash : String,entryId : String )
		{
			service= 'doubleclickdistribution_doubleclick';
			action= 'getFeedByEntryId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('distributionProfileId');
			valueArr.push(distributionProfileId);
			keyArr.push('hash');
			valueArr.push(hash);
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DoubleClickGetFeedByEntryIdDelegate( this , config );
		}
	}
}
