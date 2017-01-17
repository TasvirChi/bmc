package com.borhan.bmc.modules.content.model.types
{
	import com.borhan.types.BorhanBatchJobStatus;
	
	import mx.resources.ResourceManager;
	
	public class BulkTypes
	{

		public static function getTypeName(  bulkType : uint ) : String
		{
			switch(bulkType)
			{
				case BorhanBatchJobStatus.PENDING: return ResourceManager.getInstance().getString( 'cms' , 'verifyingFile' ); break;
				case BorhanBatchJobStatus.QUEUED: return   ResourceManager.getInstance().getString( 'cms' , 'verifyingQforI' ); break;
				case BorhanBatchJobStatus.PROCESSING: return ResourceManager.getInstance().getString( 'cms' , 'processing' ); break;
				case BorhanBatchJobStatus.FINISHED: return ResourceManager.getInstance().getString( 'cms' , 'finished' ); break; 
				case BorhanBatchJobStatus.ABORTED: return ResourceManager.getInstance().getString( 'cms' , 'aborted' ); break; 
				case BorhanBatchJobStatus.FAILED: return ResourceManager.getInstance().getString( 'cms' , 'failed' ); break; 
				case BorhanBatchJobStatus.ALMOST_DONE: return ResourceManager.getInstance().getString( 'cms' , 'almostDone' ); break; 
				case BorhanBatchJobStatus.FATAL: return ResourceManager.getInstance().getString( 'cms' , 'fatal' ); break; 
				case BorhanBatchJobStatus.RETRY: return ResourceManager.getInstance().getString( 'cms' , 'retry' ); break; 
				case BorhanBatchJobStatus.DONT_PROCESS: return ResourceManager.getInstance().getString( 'cms' , 'dontProcess' ); break; 
				case BorhanBatchJobStatus.FINISHED_PARTIALLY: return ResourceManager.getInstance().getString( 'cms' , 'finishedWErr' ); break; 
			}
			return "";
		}

	}
}
