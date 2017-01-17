package com.borhan.bmc.modules.content.view.interfaces
{
	import com.borhan.vo.BorhanBaseSyndicationFeed;
	
	/**
	 * This interface declares the methods necessary for an external syndication feed. 
	 */	
	public interface IExternalSyndicationFeed
	{
		function get syndication():BorhanBaseSyndicationFeed
		function set syndication(syndication:BorhanBaseSyndicationFeed):void
		
		function validate():Boolean
	}
}