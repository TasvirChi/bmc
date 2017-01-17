package com.borhan.edw.components.fltr.panels
{
	import com.borhan.edw.components.fltr.IAdvancedSearchFilterComponent;
	import com.borhan.edw.components.fltr.indicators.IndicatorVo;
	import com.borhan.types.BorhanSearchOperatorType;
	import com.borhan.vo.BorhanMetadataSearchItem;
	import com.borhan.vo.BorhanSearchCondition;
	import com.borhan.vo.MetadataFieldVO;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	
	public class MetadataFilter extends AdditionalFilter implements IAdvancedSearchFilterComponent {
		
		private var _initialFilter:BorhanMetadataSearchItem;
		
		
		override public function set filter(value:Object):void {
			if (!value) {
				_buttons[0].selected = true;
				for (var i:int = 1; i<_buttons.length; i++) {
					_buttons[i].selected = false;
				}
			}
			
			if (_buttons) {
				_buttons[0].selected = false;
				// scan the fields (filter.items)
				for each (var field:BorhanSearchCondition in value.items) {
					// for each field, find a matching button and select it
					for each (var cb:CheckBox in _buttons) {
						if (cb.data == field.value) {
							cb.selected = true;
							break;
						}
					}
				}
				//TODO if all buttons are selected..
			}
			else {
				// keep the value for later
				_initialFilter = value as BorhanMetadataSearchItem;
			}
		}
		
		/**
		 * filter is BorhanMetadataSearchItem whose items are BorhanSearchCondition 
		 */
		override public function get filter():Object {
			if (_buttons) {
				var fieldValueSearchCondition:BorhanSearchCondition;
				var fieldBorhanMetadataSearchItem:BorhanMetadataSearchItem = new BorhanMetadataSearchItem();
				fieldBorhanMetadataSearchItem.type = BorhanSearchOperatorType.SEARCH_OR;
				fieldBorhanMetadataSearchItem.metadataProfileId = parseInt((parent as MetadataProfileFilter).id); // value set by EntriesFilter
				fieldBorhanMetadataSearchItem.items = new Array();
				for (var i:int = 1; i < _buttons.length; i++) {
					if (_buttons[i].selected) {
						fieldValueSearchCondition = new BorhanSearchCondition();
						fieldValueSearchCondition.field = (data as MetadataFieldVO).xpath;
						fieldValueSearchCondition.value = _buttons[i].data;
						fieldBorhanMetadataSearchItem.items.push(fieldValueSearchCondition);
					}
				}
				
				if (fieldBorhanMetadataSearchItem.items.length > 0) {
					return fieldBorhanMetadataSearchItem;
				}
			}
			// if no buttons or no selected buttons, return null
			return null;
		}
		
		override public function set dataProvider(value:ArrayCollection):void {
			super.dataProvider = value;
			if (_initialFilter) {
				filter = _initialFilter;
			}
			if (_mainButtonTitle) {
				friendlyName = _mainButtonTitle;
			}
		}
		
		/**
		 * override removeItem() because data is not an object, it is just a string
		 * (don't use dataUniqueIdentifier)
		 * @param item	indicator vo representing the value to remove from the filter
		 */		
		override public function removeItem(item:IndicatorVo):void {
			// item.value is button.data
			// find correct button, set "selected", dispatch change
			// basically - dispatch a "click" from the matching button
			for each (var btn:Button in _buttons) {
				if (btn.data) {
					if (btn.data == item.value) {
						btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
					}
					else if (btn.data && item.value && btn.data == item.value) {
						btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
					}
				}
				else {
					// if no data, we use label
					if (btn.label == item.value) {
						btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));
					}
				}
			}
			
		} 
	
	}
}