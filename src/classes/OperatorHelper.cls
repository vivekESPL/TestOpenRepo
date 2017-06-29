/*  Helper class which computes comma separated  values depends on data type of field
 *	
 *	Revision History: 
 *	
 *	Version			Author				Date				Description 
 *	1.0				Amol Chaudhari		05/02/2012			Intial Draft 
 */
public with sharing class OperatorHelper {
	/* getting the string (comma separared) for the available operators corresponding to field 
	   data type  */ 
	public static String getAvailableOperators(Schema.Describefieldresult pFieldResult) {
		
		List<String> lstOperatorNumbers = new List<String>();
		String strOperators = '';
		String strOperatorNumbers = '';
		String strFieldDataType = '';
		//map of FieldType vs Operators
		map<String,String> fieldTypesVsOperatorsMap = ENV.getFieldTypeVsOprators1();
		if(pFieldResult != null){
			//getting the data type for current field
			strFieldDataType = pFieldResult.getType().name().toLowerCase();
			strOperatorNumbers = fieldTypesVsOperatorsMap.get(strFieldDataType);
		}
		
		if(String.isNotBlank(strOperatorNumbers))
			lstOperatorNumbers = strOperatorNumbers.split(',');
		
		for(String strNumOperator : lstOperatorNumbers){
			strOperators += ENV.getOpratorsMapping().get(Integer.valueOf(strNumOperator));
			strOperators += ',';
		}
		
		strOperators = strOperators.removeEnd(',');
				
		return strOperators;
	} //end method(getAvailableOperators())
}