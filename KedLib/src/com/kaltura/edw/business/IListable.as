package com.borhan.edw.business
{
	import com.borhan.controls.Paging;
	
	public interface IListable
	{
		function get filterVo():Object;
		function get pagingComponent():Paging;
	}
}