/*      Class description:    Class is developed to validate filter logic. 
*                            This will be achieved in three steps
*                             1. First check all brackets are valid
*                             2. There should not be extra characters than And, Or, not and 0-9 numbers
*                             3. It should be valid filter logic, this will be achieved using actual soql query         
*       Revision History: 
*       Version                 Author                      Date                        Description 
*       1.0                     Siddharth Birari            14/02/2013                  Initial draft
*
*/

public class ValidateFilterLogic{

    public string strErrorMessage{get;set;}
    public Map<String,String> dataTypeAndValue{get;set;}
    
    public ValidateFilterLogic()
    {
        strErrorMessage=null;
    }
    
    // method to check filter logic is correct or not
    public boolean isFilterLogicCorrect(String inputString, integer totalFilters) 
    {
        // 1st check all brackets
        if(areBracketsCorrect(inputString))
        {
            //check tokens
            if(validateTokens(inputString.split(' '),totalFilters))
            {   //check query
                return checkQuery(inputString, totalFilters);
               // return true;
            }
            else             
                return false;
            
        }
        else                     
        return false;
    } //end of method isFilterLogicCorrect
    
    
    //method to check brackets
    public boolean areBracketsCorrect(String inputString)
    {   
    
      //check if total brackets applied are valid i.e. total number of opened brackets equals closed brackets
       if(InputString != null && InputString != '')
        {
            Pattern regex = Pattern.compile('\\(([^()]*)\\)');
            Matcher m = regex.matcher(InputString);
            // Loop removes matching nested parentheses from inside out.
            while (m.find()) 
            {
                InputString = m.replaceFirst(m.group(1));
                m.reset(InputString);
            }
            regex = Pattern.compile('[()]');  
            m = regex.matcher(InputString);
            // Check if there are any erroneous parentheses left over.
            if (m.find())
            {
               
                strErrorMessage='Please enter valid parentheses';
                 return false;
            }    
            return true;
        }
         strErrorMessage='Please enter valid parentheses';   
         return false;
    } // end of method areBracketsCorrect
    
    
    
    
    //method to validate tokens, there should not be extra characters in string
    public Boolean validateTokens(List<String> lstStringTokens, integer totalFilters)
    {
        system.debug('in validateTokens' + lstStringTokens);
        for(integer i=0;i<lstStringTokens.size();i++)
        {//remove extra spaces from array
            
            
            //if(lstStringTokens[i]=='' || lstStringTokens[i]==null)
            if(lstStringTokens[i].length()==0)
            {    
                lstStringTokens.remove(i);
            }
        }   
         system.debug('after removing spaces' + lstStringTokens);
         integer j=0;
         
        for(String str:lstStringTokens)
        {    
            system.debug('in for' + str);
            
            if(str.equalsIgnoreCase('AND') || str.equalsIgnoreCase('OR') || str.equalsIgnoreCase('NOT')
             || str.isNumeric()|| str.contains('(') || str.contains(')') )
            {
                if(str.isNumeric()|| str.contains('(') || str.contains(')'))
                {   
                    //if it is a number, check that number should not be greater or less than total filters applied 
                    string validNumbers;
                    for(integer i=1;i<=totalFilters;i++)
                    {    
                         validNumbers=validNumbers+i;
                    }
                    if(str.containsAny(validNumbers)==false)
                    {    
                         system.debug('in else if' + str+','+validNumbers);   
                         strErrorMessage='Please enter valid number';
                         return false;
                    }                    
                    
                } //check if not is present in filter logic, if yes check what is after word not.
                    //allowed values are 0-9 numbers or "(" brackets  
                if(str.equalsIgnoreCase('NOT'))
                {    
                    if(j==lstStringTokens.size()-1)
                    {
                        strErrorMessage='Unexpected Token Not';
                        return false;
                    }
                    if(j<lstStringTokens.size()-1)
                    {
                        if(!lstStringTokens[j+1].isNumeric() && !lstStringTokens[j+1].contains('('))
                        {
                            strErrorMessage='Unexpected Token Not';
                            return false;
                        }
                    } 
                    
                }
            }                
            else 
            {            
                system.debug('in else' + str); 
                strErrorMessage='Please enter valid a character';
                return false;
            }    
            j++;
        }
        return true;         
    }// end of validateTokens methods
    

    //method to return field and its sample value
    //method will first check its data type and will assign value accordingly
    //string returned will be like Name='test'  
    public string sorceFieldAndValue(String fieldName, String Datatype)
    {
        dataTypeAndValue=new Map<String,String>();
        dataTypeAndValue.put('Email','\'test@test.com\'');
        dataTypeAndValue.put('String','\'test\'');
        dataTypeAndValue.put('Integer','1');
        dataTypeAndValue.put('Decimal','1.2');
        dataTypeAndValue.put('Double','1.2');        
        dataTypeAndValue.put('Long','1.2');
        dataTypeAndValue.put('Date','2012-12-12');
        dataTypeAndValue.put('DateTime','2012-12-12T10:10:10:000Z');
        dataTypeAndValue.put('Boolean','false');        
        string condition= fieldName+'='+dataTypeAndValue.get(Datatype);        
        return condition;
    } // end of method sorceFieldAndValue
    
    
    //method to check filter logic by doing query on object
    public boolean checkQuery(String inputString, integer totalFilters)
    {    
        //sourceFields should be like name,email
        //inputString should be like 1 or 2 or 3 1 or not 2
        //objectToQuery should be like Account
        
        //List<String> lstSourceFields=sourceFields.split(',');
        //List<String> lstDatatypes=Datatypes.split(',');
        String whereClause= inputString;
        whereClause=whereClause.toLowerCase(); // convert inputstring to lower case
        whereClause=whereClause.remove('not');// remove all not words from string
        //replace number 10 with 0 in order to keep all 10 numbers unique
        //whereClause=whereClause.replace('10','0');
                   
                         
        for(integer i=totalFilters;i>=1;i--)
        {            
            whereClause=whereClause.replace(String.valueof(i),sorceFieldAndValue('Name','String'));           
        }    
           
        system.debug('before try'+ whereClause);
        try{
                    
            string dynamicQuery='Select id from Account where '+whereClause +'';        
            system.debug('in try'+dynamicQuery);
            List<Sobject> queryResult=Database.query(dynamicQuery);
            system.debug(queryResult);
            return true;
        }
        catch(System.QueryException e){
            System.debug(e.getMessage());
            strErrorMessage='Please enter a valid filter logic';
            return false;
        }                            
         strErrorMessage='Please enter a valid filter logic';
        return false;
    }
}