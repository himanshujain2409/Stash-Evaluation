/*
* Controller for ApttusCustomerPortalInstall page
* @author Copyright (c) 2013 Apttus.
* @author lferreira@altimetrik.com
*/ 
public with sharing class ACPTrainingController {
	
	/* the courses to display */
	public List<ACP_Course__c> courses{get; set;}
	
	/* the selected course (for tracking functionality) */
	public String courseId{get; set;}
	
	/* get all the courses and initialize the variables in the constructor */
	public ACPTrainingController(){
		courses = [	SELECT Name, Description__c, Link__c, LinkName__c, Category__c, Id,
					(SELECT Id, Name, Description FROM Attachments WHERE IsPrivate = false ORDER BY LastModifiedDate DESC LIMIT 1)
					FROM ACP_Course__c 
					WHERE Show_On_Customer_Portal__c = true
					ORDER BY Category__c desc, Name asc];
	}
	
	/* categories to display */
	public List<String> categoriesToDisplay{
		get{
			return getCategoriesList();
		}
		private set;
	}
	
	/* helper method to get the categories defined */
	private List<String> getCategoriesList(){
		List<String> result = new List<String>();
		List<Schema.PicklistEntry> catList = ACP_Course__c.Category__c.getDescribe().getPicklistValues();
		
		for(Schema.PicklistEntry pick : catList){
			result.add(pick.getValue());
		}
		
		return result;
	}
	
	/* record the tracking information */
	public void askForItTrack(){
		
		/* save the track informtation */
		ACP_Course_Download__c download = new ACP_Course_Download__c(
			Course__c = courseId,
			User__c = ACPUtils.getCurrentUser().Id,
			isEmail__c = true
		);
		
		insert download;
	}
	
	/* record the tracking information */
	public void downloadTrack(){
		
		/* save the track informtation */
		ACP_Course_Download__c download = new ACP_Course_Download__c(
			Course__c = courseId,
			User__c = ACPUtils.getCurrentUser().Id,
			isEmail__c = false
		);
		
		insert download;
	}
	
	
	/* wrapper inner class to display */
	public class CourseWrapper{
		
		public ACP_Course__c course{get; private set;}
		public String aCategory{get; private set;}
		
		public CourseWrapper(){
			course = null;
			aCategory = '';
		}
	}
}