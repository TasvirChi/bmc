package com.borhan.edw.business {
	import com.borhan.dataStructures.HashMap;
	import com.borhan.edw.business.base.FormBuilderBase;
	import com.borhan.edw.model.MetadataDataObject;
	import com.borhan.edw.model.datapacks.ContextDataPack;
	import com.borhan.edw.model.datapacks.DistributionDataPack;
	import com.borhan.edw.model.datapacks.EntryDataPack;
	import com.borhan.edw.model.datapacks.FilterDataPack;
	import com.borhan.edw.model.types.CustomMetadataConstantTypes;
	import com.borhan.edw.view.customData.EntryIDLinkTable;
	import com.borhan.bmvc.model.BMvCModel;
	import com.borhan.vo.BMCMetadataProfileVO;
	
	import mx.core.UIComponent;

	/**
	 * This class is used for building UI components according to a given
	 * metadata profile and a view XML.
	 */
	[Bindable]
	public class EntryFormBuilder extends FormBuilderBase{
		
		private var _model:BMvCModel = BMvCModel.getInstance();
		


		/**
		 * Builds a new FormBuilder instance
		 * @param metadataProfile the metadata profile which will be used to build the proper
		 * UI components
		 *
		 */
		public function EntryFormBuilder(metadataProfile:BMCMetadataProfileVO) {
			var dummyTable:EntryIDLinkTable;
			
			super(metadataProfile);
		}

		
		override protected function handleNonVBoxFieldDataHook(field:XML, valuesHashMap:HashMap):Boolean{
			var metadataDataAttribute:String = field.@metadataData;
			//in linked entry we want all the values array
			if (field.@id == CustomMetadataConstantTypes.ENTRY_LINK_TABLE){
				field.@[metadataDataAttribute] = valuesHashMap.getValue(field.@name);
				return true;
			}
			
			return false;
		}

		
		override protected function buildObjectFieldNodeHook(componentMap:HashMap, multi:Boolean):XML{
			var fieldNode:XML = XML(componentMap.getValue(CustomMetadataConstantTypes.ENTRY_LINK_TABLE)).copy();
			if (!multi)
				fieldNode.@maxAllowedValues = "1";
			
			return fieldNode;
		}

		
		override protected function buildComponentCheckHook(componentNode:XML, compInstance:UIComponent):void{
			if (componentNode.@id == CustomMetadataConstantTypes.ENTRY_LINK_TABLE) {
				compInstance["context"] = _model.getDataPack(ContextDataPack);
				compInstance["profileName"] = _metadataProfile.profile.name;
			}
		}
		
		override protected function handleComponentTypePropertiesHook(component:XML, compInstance:UIComponent, boundModel:MetadataDataObject):Boolean{
			if (component.@id == CustomMetadataConstantTypes.ENTRY_LINK_TABLE) {
				compInstance.id = component.@name;
				compInstance["metadataObject"] = boundModel;
				// pass relevant model parts:
				compInstance["filterModel"] = (_model.getDataPack(FilterDataPack) as FilterDataPack).filterModel;
				compInstance["distributionProfilesArr"] = (_model.getDataPack(DistributionDataPack) as DistributionDataPack).distributionInfo.distributionProfiles;
				compInstance["editedItem"] = (_model.getDataPack(EntryDataPack) as EntryDataPack).selectedEntry;
				
				return true;
			}
			return false;
		}



	}
}