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
package com.borhan.commands.metadataBatch
{
		import com.borhan.vo.BorhanExclusiveLockKey;
		import com.borhan.vo.BorhanBatchJobFilter;
	import com.borhan.delegates.metadataBatch.MetadataBatchGetExclusiveTransformMetadataJobsDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* batch getExclusiveTransformMetadataJob action allows to get a BatchJob of type METADATA_TRANSFORM
	**/
	public class MetadataBatchGetExclusiveTransformMetadataJobs extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param lockKey BorhanExclusiveLockKey
		* @param maxExecutionTime int
		* @param numberOfJobs int
		* @param filter BorhanBatchJobFilter
		* @param maxOffset int
		**/
		public function MetadataBatchGetExclusiveTransformMetadataJobs( lockKey : BorhanExclusiveLockKey,maxExecutionTime : int,numberOfJobs : int,filter : BorhanBatchJobFilter=null,maxOffset : int=int.MIN_VALUE )
		{
			service= 'metadata_metadatabatch';
			action= 'getExclusiveTransformMetadataJobs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
				keyValArr = borhanObject2Arrays(lockKey, 'lockKey');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('maxExecutionTime');
			valueArr.push(maxExecutionTime);
			keyArr.push('numberOfJobs');
			valueArr.push(numberOfJobs);
			if (filter) { 
				keyValArr = borhanObject2Arrays(filter, 'filter');
				keyArr = keyArr.concat(keyValArr[0]);
				valueArr = valueArr.concat(keyValArr[1]);
			} 
			keyArr.push('maxOffset');
			valueArr.push(maxOffset);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataBatchGetExclusiveTransformMetadataJobsDelegate( this , config );
		}
	}
}
