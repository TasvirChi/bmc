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
package com.borhan.commands.tvCom
{
	import com.borhan.delegates.tvCom.TvComGetFeedDelegate;
	import com.borhan.net.BorhanCall;

	/**
	**/
	public class TvComGetFeed extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param distributionProfileId int
		* @param hash String
		**/
		public function TvComGetFeed( distributionProfileId : int,hash : String )
		{
			service= 'tvcomdistribution_tvcom';
			action= 'getFeed';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('distributionProfileId');
			valueArr.push(distributionProfileId);
			keyArr.push('hash');
			valueArr.push(hash);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new TvComGetFeedDelegate( this , config );
		}
	}
}
