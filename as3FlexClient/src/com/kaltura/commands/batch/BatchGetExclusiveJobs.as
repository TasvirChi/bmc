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
package com.borhan.commands.batch
{
		import com.borhan.vo.BorhanExclusiveLockKey;
		import com.borhan.vo.BorhanBatchJobFilter;
	import com.borhan.delegates.batch.BatchGetExclusiveJobsDelegate;
	import com.borhan.net.BorhanCall;

	/**
	* batch getExclusiveJobsAction action allows to get a BatchJob
	**/
	public class BatchGetExclusiveJobs extends BorhanCall
	{
		public var filterFields : String;
		
		/**
		* @param lockKey BorhanExclusiveLockKey
		* @param maxExecutionTime int
		* @param numberOfJobs int
		* @param filter BorhanBatchJobFilter
		* @param jobType String
		* @param maxOffset int
		**/
		public function BatchGetExclusiveJobs( lockKey : BorhanExclusiveLockKey,maxExecutionTime : int,numberOfJobs : int,filter : BorhanBatchJobFilter=null,jobType : String = null,maxOffset : int=int.MIN_VALUE )
		{
			service= 'batch';
			action= 'getExclusiveJobs';

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
			keyArr.push('jobType');
			valueArr.push(jobType);
			keyArr.push('maxOffset');
			valueArr.push(maxOffset);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BatchGetExclusiveJobsDelegate( this , config );
		}
	}
}
