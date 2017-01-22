package com.borhan.edw.model
{
	import com.borhan.vo.BorhanDistributionProfile;
	import com.borhan.vo.BorhanEntryDistribution;

	/**
	 * This class represents an entry distribution 
	 * @author Michal
	 * 
	 */	
	[Bindable]
	public class EntryDistributionWithProfile
	{
		/**
		 * describes the entry distribution 
		 */		
		public var borhanEntryDistribution:BorhanEntryDistribution;
		/**
		 * describes the distribution profile for current entry distribution 
		 */		
		public var borhanDistributionProfile:BorhanDistributionProfile;
		/**
		 * whether the entry will be automatic distributed or not 
		 * In case this value is true but the profile is configured otherwhise, this parameter has no meaning 
		 */		
		public var manualQualityControl:Boolean = true;
		
		/**
		 * Whether the distributor is selected in the select distributors window.
		 * */
		public var distributorSelected:Boolean = false;
		/**
		 * The distributor state that the select distributors window was initialize with
		 * */
		public var distributorInitState:Boolean = false;
		/**
		 * Whether the entry will be sent automatically or not
		 * */
		public var distributeAutomatically:Boolean = false;
		/**
		 * Whether to enable selecting distributor
		 * */
		public var enableSelectingDistributor:Boolean = true;
		/**
		 * Whether to enable automatic submission
		 * */
		public var enableAutomaticSubmission:Boolean = true;
		
		public function EntryDistributionWithProfile()
		{
		}

	}
}