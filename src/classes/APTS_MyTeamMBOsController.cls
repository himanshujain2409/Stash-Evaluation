/* APTS_MyTeamMBOsController
 * Ucontroller class for APTS_MyTeamMBOs page.
 *
 * Developer: Harish Emmadi, APTTUS
 * Business Owner: Szymon K
 *
 * Scenario:
 * 
 * 
 *
 * History:
 
 * 02/20/2015, Harish Emmadi, APTTUS - created APTS_MyTeamMBOsController class.
 * 03/04/2015, KrishnaRajani Yadlapalli, APTTUS - modified some logic in MBO and performance dispaly.
 */
public with sharing class APTS_MyTeamMBOsController {
	public String selectedyearValue{get; set;}

	/* Added by J Gorti */
	public Boolean selfReviewCompleted{get; set;}
	
	Id loggedinuserId;
	Map<String, List<MBO__c>> yeartomyMBOsMap;
	Map<String, List<Performance_Reviews__c>> yeartomyprfeedbackMap;
	Map<String, List<Performance_Reviews__c>> yeartomyteamprfeedbackMap;
	Map<id, user> mapUser;
	
	public APTS_MyTeamMBOsController() {
		loggedinuserId = UserInfo.getUserId();
		


		mapUser = new Map<Id, user>();
		for (User usr : APTS_MBOHelper.getEmployees(loggedinuserId)){
			mapUser.put(usr.id, usr);
		}


		yeartomyMBOsMap = new Map<String, List<MBO__c>>();
		for(MBO__c mbo : APTS_MBOHelper.getEmployeeMbos(loggedinuserId)){ 
			String year = mbo.MBO_Year__c;
			if(String.isNotBlank(year))
			{
				List<MBO__c> mboList = yeartomyMBOsMap.containskey(year) ? yeartomyMBOsMap.get(year) : new List<MBO__c>();
				mboList.add(mbo);
				yeartomyMBOsMap.put(year, mboList);
        	}
        }

        yeartomyprfeedbackMap = new Map<String, List<Performance_Reviews__c>>();
		for(Performance_Reviews__c prfeedback : APTS_MBOHelper.getEmployeePerfReviews(loggedinuserId, null)){ 
			String year = prfeedback.MBO_Year__c;
			if(String.isNotBlank(year))
			{
				List<Performance_Reviews__c> prfeedbackList = yeartomyprfeedbackMap.containskey(year) ? yeartomyprfeedbackMap.get(year) : new List<Performance_Reviews__c>();
				prfeedbackList.add(prfeedback);
				yeartomyprfeedbackMap.put(year, prfeedbackList);
        	}
        }

        yeartomyteamprfeedbackMap = new Map<String, List<Performance_Reviews__c>>();
		for(Performance_Reviews__c prfeedback : APTS_MBOHelper.getTeamPerfReviews(loggedinuserId)){ 
			String year = prfeedback.MBO_Year__c;
			if(String.isNotBlank(year))
			{
				List<Performance_Reviews__c> prfeedbackList = yeartomyteamprfeedbackMap.containskey(year) ? yeartomyteamprfeedbackMap.get(year) : new List<Performance_Reviews__c>();
				prfeedbackList.add(prfeedback);
				yeartomyteamprfeedbackMap.put(year, prfeedbackList);
        	}
        }
	}

	public Component.Apex.TabPanel getTabbedView()
	{
		Component.Apex.TabPanel panel = new Component.Apex.TabPanel(
												switchType = 'client', immediate = false);
		
		Integer currentyear = Date.today().year();
		Integer tabscount;
		try{
			Parm__c parm = Parm__c.getInstance(APTS_CONSTANTS.PARM_TABSCOUNT_MBOPAGE);
			tabscount = Integer.valueOf(parm.Parm_number__c);
		}
		catch(Exception ex){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,APTS_CONSTANTS.PARM_TABSCOUNT_MBOPAGE+' record missing from Parm__c custom setting.'));
			return null;
		}
		for(Integer i = 0; i < tabscount; i++)
		{
			String year = String.valueOf(currentyear);
			Component.Apex.Tab tab = new Component.Apex.Tab();
			tab.label = year;

			/********************Start of My MBOs panel**********************/
			Component.Apex.outputPanel mymbosoppanel = new Component.Apex.outputPanel();

			Component.Apex.Pageblock mymbospgblock = new Component.Apex.Pageblock();
			mymbospgblock.title = 'My MBOs';
			
			if(yeartomyMBOsMap.containsKey(year))
			{
				List<MBO__c> mymboList = yeartomyMBOsMap.get(year);

				Component.Apex.PageblockTable mymbostable = new Component.Apex.PageblockTable();
				mymbostable.value = mymboList;
				mymbostable.var = 'mymbo';
				
				Component.Apex.Column actioncolumn = new Component.Apex.Column();
				Component.Apex.outputLink viewlink = new Component.Apex.outputLink(target = '_blank', title = 'View');
				viewlink.expressions.value = '/{!mymbo.Id}';
				
				Component.Apex.outputText viewlinktxt = new Component.Apex.outputText(value = 'View');
				
				viewlink.childComponents.add(viewlinktxt);
				actioncolumn.childComponents.add(viewlink);
				actioncolumn.Headervalue = 'Action';

				Component.Apex.Column firstCol = new Component.Apex.Column();
				firstCol.expressions.value = '{!mymbo.Name}';
				
				Component.Apex.Column secondCol = new Component.Apex.Column();
				secondCol.expressions.value = '{!mymbo.Status__c}';
				//secondCol.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Title__c.label}';

				Component.Apex.Column thirdCol = new Component.Apex.Column();
				thirdCol.expressions.value = '{!mymbo.Manager__r.Name}';
				thirdCol.Headervalue = 'Manager';

				Component.Apex.Column fourthCol = new Component.Apex.Column();
				fourthCol.expressions.value = '{!mymbo.MBO_1__c}';
				//fourthCol.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Status__c.label}';

				Component.Apex.Column fifthCol = new Component.Apex.Column();
				fifthCol.expressions.value = '{!mymbo.MBO_2__c}';

				Component.Apex.Column sixthCol = new Component.Apex.Column();
				sixthCol.expressions.value = '{!mymbo.MBO_3__c}';

				mymbostable.childComponents.add(actioncolumn);
				mymbostable.childComponents.add(firstCol);
				mymbostable.childComponents.add(secondCol);
				mymbostable.childComponents.add(thirdCol);
				mymbostable.childComponents.add(fourthCol);
				mymbostable.childComponents.add(fifthCol);
				mymbostable.childComponents.add(sixthCol);
				
				mymbospgblock.childComponents.add(mymbostable);

				
				/*Component.Apex.pageBlockButtons mymbospgblockbuttons = new Component.Apex.pageBlockButtons(location = 'bottom');
				//add command buttons to my MBOs pageblock.
				//Showing Command buttons based on MBO Self Feedback and Peformance Feedback Performance Review Complated flags
                for(MBO__c mbo : mymboList){
                    if(mbo.Year_Quarter__c == 'Q3/Q4' 
                    	&& mbo.Enable_Self_Review__c){ //Fprreviewor Q3/Q4 mbo if enable self review is checked
                        Component.Apex.CommandButton cmdbtn = new Component.Apex.CommandButton();

                        if(yeartomyprfeedbacksMap.containsKey(mbo.MBO_Year__c)){
                           for(Performance_Reviews__c prfeedback : yeartomyprfeedbacksMap.get(mbo.MBO_Year__c)){
                                if(prfeedback.Self_Review_Completed__c){
                                    cmdbtn.value = 'View Self Feedback';
                                    cmdbtn.expressions.action='{!viewPerformanceFeedback}';
                                }else{
                                    cmdbtn.value = 'Edit Self Feedback';
                                    cmdbtn.expressions.action = '{!editPerformanceFeedback}';
                                }
                            } 
                        }else{
                             cmdbtn.value = 'Start Self Feedback';
                             cmdbtn.expressions.action = '{!addPerformanceFeedback}';
                        }
                        cmdbtn.onclick='performanceReview('+year+')';

                        mymbospgblockbuttons.childcomponents.add(cmdbtn);
                        mymbospgblock.childComponents.add(mymbospgblockbuttons);
                        break;
                    }
                }*/
			}
			
			mymbosoppanel.childComponents.add(mymbospgblock);
			/********************End of My MBOs panel**********************/

			/********************Start of My Performance Feedback panel**********************/
			Component.Apex.outputPanel myprfeedbackoppanel = new Component.Apex.outputPanel();

			Component.Apex.Pageblock myprfeedbackpgblock = new Component.Apex.Pageblock();
			myprfeedbackpgblock.title = 'My Performance Feedback';

			myprfeedbackpgblock.rendered = false;// do not render the My Performance Feedback block unless it has performance feed back or 'self review' button enabled.
			System.debug('OUR MAP ----------------------- ' + yeartomyMBOsMap);
			System.debug('OUR MAP ----------------------- ' + year);
			System.debug('OU MAP -------------------------' + yeartomyMBOsMap.get(year));
			
			/* Changed made by JPG */
			if(yeartomyprfeedbackMap.containsKey(year))
			{
				List<Performance_Reviews__c> myprfeedbackList = yeartomyprfeedbackMap.get(year);

				Component.Apex.PageblockTable myprfeedbacktable = new Component.Apex.PageblockTable();
				myprfeedbacktable.value = myprfeedbackList;
				myprfeedbacktable.var = 'myprfeedback';

				
				//selfReviewCompleted = myprfeedback.Self_Review_Completed__c;

				Component.Apex.Column hiddencolumn_pr = new Component.Apex.Column();
				hiddencolumn_pr.expressions.value = '{!myprfeedback.Self_Review_Completed__c}';
				hiddencolumn_pr.rendered = false;
				//System.Debug('TTTTTTTTTTTT-----------' + hiddencolumn_pr.expressions.value);
				

				Component.Apex.Column actioncolumn_pr = new Component.Apex.Column();
	
				Component.Apex.outputLink editlink = new Component.Apex.outputLink(title = '{!IF(myprfeedback.Self_Review_Completed__c == true,"Edit","View")}');
				editlink.expressions.value = '/apex/APTS_MBOPerformanceReview?id={!myprfeedback.Id}';
				


				Component.Apex.outputText txt = new Component.Apex.outputText();
				//Component.Apex.outputText txt = new Component.Apex.outputText(value = 'View');
				//txt.expressions.rendered = '{!myprfeedback.Self_Review_Completed__c == true}';
				//txt.value = 'View';

				//Component.Apex.outputText txt1 = new Component.Apex.outputText(value = 'Edit');
				//txt1.expressions.rendered = '{!myprfeedback.Self_Review_Completed__c == false}';
				//txt1.value = 'Edit';
				
				txt.expressions.value = '{!IF(myprfeedback.Self_Review_Completed__c == true, "View", "Edit")}';
				editlink.childComponents.add(txt);
				//editlink.childcomponents.add(txt1);
				actioncolumn_pr.childComponents.add(editlink);

				actioncolumn_pr.Headervalue = 'Action';
				

				/*
				Component.Apex.outputLink editlink = new Component.Apex.outputLink(title = '');
				editlink.expressions.value = '/apex/APTS_MBOPerformanceReview?id={!myprfeedback.Id}';
				Component.Apex.outputText txt = new Component.Apex.outputText();
				txt.value = '"{!myprfeedback.Employee_Name__c}"';
				editlink.childComponents.add(txt);
				*/

				Component.Apex.Column firstCol_pr = new Component.Apex.Column();
				firstCol_pr.expressions.value = '{!myprfeedback.Employee__r.Name}';
				//editlink.childComponents.add(txt);
				//firstCol_pr.childComponents.add(editlink);
				firstCol_pr.Headervalue = 'Employee Name';

				Component.Apex.Column secondCol_pr = new Component.Apex.Column();
				secondCol_pr.expressions.value = '{!myprfeedback.Title__c}';
				//secondCol_pr.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Title__c.label}';

				Component.Apex.Column thirdCol_pr = new Component.Apex.Column();
				thirdCol_pr.expressions.value = '{!myprfeedback.Status__c}';
				//thirdCol_pr.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Status__c.label}';

				myprfeedbacktable.childComponents.add(hiddencolumn_pr);
				myprfeedbacktable.childComponents.add(actioncolumn_pr);
				myprfeedbacktable.childComponents.add(firstCol_pr);
				myprfeedbacktable.childComponents.add(secondCol_pr);
				myprfeedbacktable.childComponents.add(thirdCol_pr);
				
				myprfeedbackpgblock.childComponents.add(myprfeedbacktable);
				myprfeedbackpgblock.rendered = true; // render my performance feedback block if performance feedback are available.
			//-- JPG
			}

			else if(yeartomyMBOsMap.containsKey(year)
					&& yeartomyMBOsMap.get(year).size() > 0){
		
		


		// add 'Start Self Feedback' button to pageblock. only if Q3/Q4 MBO's exists with Enable_Self_Review__c checked for the year.
				List<MBO__c> mboList = yeartomyMBOsMap.get(year);
				for(MBO__c mbo : mboList){
					if(APTS_CONSTANTS.MBO_YQ_34.equalsIgnoreCase(mbo.Year_Quarter__c)
						&& mbo.Enable_Self_Review__c == true)
					{
						Component.Apex.pageBlockButtons myprfeedbackpgblockbuttons = new Component.Apex.pageBlockButtons(location = 'top');

						Component.Apex.CommandButton cmdbtn = new Component.Apex.CommandButton();
						cmdbtn.value = 'Start Self Feedback';
		             	cmdbtn.expressions.action = '{!addPerformanceFeedback}';
						cmdbtn.onclick='performanceReview('+year+')';
						cmdbtn.rendered = false;
						
						myprfeedbackpgblockbuttons.childcomponents.add(cmdbtn);
						myprfeedbackpgblock.childComponents.add(myprfeedbackpgblockbuttons);
						myprfeedbackpgblock.rendered = true;// render my performance feedback block if when 'self review' button is enabled.
					}
				}
				
			} 
			
			myprfeedbackoppanel.childComponents.add(myprfeedbackpgblock);
			/********************End of My Performance Feedback panel**********************/

			/********************Start of My Team MBOs panel**********************/
			Component.Apex.outputPanel myteammbosoppanel = new Component.Apex.outputPanel();
			Component.APTS_MyTeamMBOsHierarchyTree tree = new Component.APTS_MyTeamMBOsHierarchyTree(yearvalue = year);
			myteammbosoppanel.childComponents.add(tree);
			/********************End of My Team MBOs panel**********************/
			
			/********************Start of My Team performance Feedback panel**********************/
			Component.Apex.outputPanel prfeedbackoppanel = new Component.Apex.outputPanel();

			if(yeartomyteamprfeedbackMap.containsKey(year))
			{
				Component.Apex.Pageblock prfeedbackpgblock = new Component.Apex.Pageblock();
				prfeedbackpgblock.title = 'My Team Performance Feedback';

				Component.Apex.PageblockTable prfeedbacktable = new Component.Apex.PageblockTable();
				prfeedbacktable.value = yeartomyteamprfeedbackMap.get(year);/*[Select Id, Name, MBO_Year__c, Employee__r.Name, Employee__c, Status__c, Overall_Rating__c,
															  MBO_Q1_Q2__r.Name, MBO_Q1_Q2__c, MBO_Q3_Q4__r.Name, MBO_Q3_Q4__c, Title__c
															  		From Performance_Reviews__c	
																		Where Manager__c = :loggedinuserId
																	      	  AND MBO_Year__c = :year];*/
				prfeedbacktable.var = 'prfeedback';
				
				Component.Apex.Column actioncolumn_prteam = new Component.Apex.Column();
				Component.Apex.outputLink editlink1 = new Component.Apex.outputLink(title = 'Edit');
				editlink1.expressions.value = '/apex/APTS_MBOPerformanceReview?id={!prfeedback.Id}';
				
				Component.Apex.outputText txt1 = new Component.Apex.outputText(value = 'Edit');
				//txt.expressions.value = '{!prfeedback.Employee__r.Name}';// not working - should be resolved.
				
	            editlink1.childComponents.add(txt1);
				actioncolumn_prteam.childComponents.add(editlink1);
				actioncolumn_prteam.Headervalue = 'Action';

				Component.Apex.Column firstCol_prteam = new Component.Apex.Column();
				firstCol_prteam.expressions.value = '{!prfeedback.Employee__r.Name}';
				firstCol_prteam.Headervalue = 'Employee Name';

				Component.Apex.Column secondCol_prteam = new Component.Apex.Column();
				secondCol_prteam.expressions.value = '{!prfeedback.Title__c}';
				//secondCol_prteam.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Title__c.label}';

				Component.Apex.Column thirdCol_prteam = new Component.Apex.Column();
				thirdCol_prteam.expressions.value = '{!prfeedback.Status__c}';
				//thirdCol_prteam.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Status__c.label}';

				Component.Apex.Column fourthCol_prteam = new Component.Apex.Column();
				fourthCol_prteam.expressions.value = '{!prfeedback.Review_Visible_to_Employee__c}';
				//fourthCol_pr.Headervalue = '{!$ObjectType.Performance_Reviews__c.fields.Review_Visible_to_Employee__c.label}';

				prfeedbacktable.childComponents.add(actioncolumn_prteam);
				prfeedbacktable.childComponents.add(firstCol_prteam);
				prfeedbacktable.childComponents.add(secondCol_prteam);
				prfeedbacktable.childComponents.add(thirdCol_prteam);
				prfeedbacktable.childComponents.add(fourthCol_prteam);
				
				prfeedbackpgblock.childComponents.add(prfeedbacktable);
				prfeedbackoppanel.childComponents.add(prfeedbackpgblock);
			}
			/********************End of My Team  performance Feedback Panel**********************/

			tab.childComponents.add(mymbosoppanel);// add my MBPs panel
			tab.childcomponents.add(myprfeedbackoppanel);// add my Perfromance Feedback panel
			tab.childComponents.add(myteammbosoppanel);// add my Team MBOs panel
			tab.childComponents.add(prfeedbackoppanel);// add my Team Performance Feedback panel
			panel.childComponents.add(tab);

			currentyear -- ;
		}
		return panel;
	}

	//Method to Create  Performance feedback
    public PageReference addPerformanceFeedback(){
        System.debug('selectedyearValue--'+selectedyearValue);
        try
        {
            Performance_Reviews__c perrev = APTS_MBOHelper.preparePerfRev(selectedyearValue, yeartomyMBOsMap.get(selectedyearValue));
            insert perrev;
            
            PageReference prfeedbackpage = new PageReference('/apex/APTS_MBOPerformanceReview?id='+perrev.Id);
			return prfeedbackpage;
		}catch(Exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
        //return Page.APTS_MBOPerformanceReview;
    }

    /*
    //Method to Edit  Performance feedback
     public PageReference editPerformanceFeedback(){
        System.debug('selectedyearValue--'+selectedyearValue);
        if(selectedyearValue != null
           && yeartomyprfeedbackMap.containsKey(selectedyearValue))
        {
            Performance_Reviews__c perrev = yeartomyprfeedbackMap.get(selectedyearValue).get(0);
        	PageReference prfeedbackpage = new PageReference('/apex/APTS_MBOPerformanceReview?id='+perrev.Id);
			return prfeedbackpage;
        }
        return null;
		//return Page.APTS_MBOPerformanceReview;
    }

    Method to View  Performance feedback
     public PageReference viewPerformanceFeedback(){
        System.debug('selectedyearValue--'+selectedyearValue);
        if(selectedyearValue != null 
           && yeartomyprfeedbackMap.containsKey(selectedyearValue))
        {
            Performance_Reviews__c perrev = yeartomyprfeedbackMap.get(selectedyearValue).get(0);
        	PageReference prfeedbackpage = new PageReference('/apex/APTS_MBOPerformanceReview?id='+perrev.Id);
			return prfeedbackpage;
        }
        return null;
		//return Page.APTS_MBOPerformanceReview;
    }*/
}