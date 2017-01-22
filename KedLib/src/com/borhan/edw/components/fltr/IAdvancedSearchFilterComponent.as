package com.borhan.edw.components.fltr
{
	/**
	 * Marker interface for filter components who use the BorhanFilter's advancedSearch capabilities.
	 * when processing the change of this component, its content will be added to <code>BorhanFilter.advancedSearch</code>
	 * instead of being processed directly on the filter. 
	 * @author atar.shadmi
	 * 
	 */
	public interface IAdvancedSearchFilterComponent extends IFilterComponent {
		
		
	}
}