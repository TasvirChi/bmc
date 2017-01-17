package com.borhan.bmc.modules.account.view.interfaces
{
	public interface IUndoable
	{
		function isChanged() : Boolean; 
		function undo() : void; 
		function saveChanges() : void;
		function resetClonedData() : void;
	}
}