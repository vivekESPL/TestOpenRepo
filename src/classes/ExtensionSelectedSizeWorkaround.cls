public with sharing class ExtensionSelectedSizeWorkaround 
{
	 ApexPages.StandardSetController setCon;

    public ExtensionSelectedSizeWorkaround(ApexPages.StandardSetController controller) {
        setCon = controller;
    }

    public integer getMySelectedSize() {
        return setCon.getSelected().size();
    }
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }

}