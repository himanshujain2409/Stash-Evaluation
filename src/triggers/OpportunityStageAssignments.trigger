trigger OpportunityStageAssignments on Opportunity (after insert, after update) {

	List<Opportunity> ops = new List<Opportunity>();
	List<Opportunity> opsOld = new List<Opportunity>();

	//system.debug('\n Trigger.New: ' + Trigger.New);

	//system.debug('\n Trigger.Old: ' + Trigger.Old);

	//Trigger.New[0].addError('<script>alert("1");</script>');

	//collect all objects changed
	for (Opportunity op : Trigger.New) {
		ops.add(op);
	}

	String OldStageName;

	//collect all objects changed
	if(Trigger.Old != null){
		for (Opportunity op : Trigger.Old) {
			opsOld.add(op);
		}
		OldStageName = opsOld[0].StageName;
	} else {
		OldStageName = null;
	}

List<lmscons__Transcript_Line__c> tlc = new List<lmscons__Transcript_Line__c>();
List<lmscons__Transcript_Line__c> tlpc = new List<lmscons__Transcript_Line__c>();

if(ops[0].StageName != OldStageName){

	system.debug('\n ops: ' + 'size: ' + ops.size()+ ' -- ' + ops);

	//get userrole name
	String userRoleName = '';

	try {
		userRoleName = [select Name from UserRole where id=:UserInfo.getUserRoleId()].Name;
	} catch (System.Queryexception e){

	}

	// search OA by Opportunity Stage
	List<OpportunityAssignment__c> oas = new List<OpportunityAssignment__c>([Select Id, User_Roles__c FROM OpportunityAssignment__c where Opportunity_Stage__c =: ops[0].StageName]);

	system.debug('\n oas: ' + oas);

	// search Competitor
	List<OpportunityCompetitor> oppComps = new List<OpportunityCompetitor>([Select Id, CompetitorName FROM OpportunityCompetitor where OpportunityId =: ops[0].Id]);

	system.debug('\n oppComps: ' + oppComps);

	//if find Opportunity Stage check user role name
	if(oas.size() > 0){

		set<id> oasIds = new set<id>();

		List<OpportunityAssignment__c> goodOa = new List<OpportunityAssignment__c>();

		map<ID, OpportunityAssignment__c> goodOaMap = new map<ID, OpportunityAssignment__c>();

		for(OpportunityAssignment__c oa: oas){

			system.debug('\n oa: ' + oa.User_Roles__c);
			system.debug('\n oa ur: ' + oa.User_Roles__c.contains(userRoleName));

			List<String> nOAs = oa.User_Roles__c.split('\n');

			if(nOAs.size() > 0){
				for(String o : nOAs){
					if(o == userRoleName){
						goodOa.add(oa);
						goodOaMap.put(oa.id, oa);
						oasIds.add(oa.id);
					}
				}
			}

			/*if(oa.User_Roles__c.contains(userRoleName) == true){
				goodOa.add(oa);
				goodOaMap.put(oa.id, oa);
				oasIds.add(oa.id);
			}*/
		}

		List<OpportunityAssignment__c> goodOaFinal = new List<OpportunityAssignment__c>();
		Map<Id, OpportunityAssignment__c> goodOaFinalMap = new Map<Id, OpportunityAssignment__c>();
		set<id> oasIdsFinal = new set<id>();

		List<Competitor2__c> compOAs = new List<Competitor2__c>([select Competitors__c from Competitor2__c where OpportunityAssignment__c IN :oasIds]);

		if(oppComps.size()>0){

			for(OpportunityCompetitor oc : oppComps){

				for(Id oasId : oasIds){

					for(Competitor2__c compOA : compOAs){
						if(oc.CompetitorName == compOA.Competitors__c){
							if (goodOaFinalMap.containsKey(oasId) == false) {
								goodOaFinalMap.put(oasId, goodOaMap.get(oasId));
								oasIdsFinal.add(oasId);
							}
							//goodOaFinal.add(goodOaMap.get(oasId));
						}
					}

				}

			}
			goodOaFinal.addAll(goodOaFinalMap.values());
		} else {
			oasIdsFinal.addAll(oasIds);
			goodOaFinal.addAll(goodOa);
		}

			// get or create Transcript id for user
			List<lmscons__Transcript__c> ex_transcript = new List<lmscons__Transcript__c>([select Id,lmscons__Trainee__c from lmscons__Transcript__c where lmscons__Trainee__c =: UserInfo.getUserId()]);

			Id trId;

			if(ex_transcript.size()>0){
				trId = ex_transcript[0].Id;
			} else {
				List<lmscons__Transcript__c> new_transcripts = new List<lmscons__Transcript__c>();
				lmscons__Transcript__c t = new lmscons__Transcript__c(
					lmscons__Trainee__c = UserInfo.getUserId()
				);
				new_transcripts.add(t);
				if (new_transcripts.size() > 0) {
					insert new_transcripts;
					trId = new_transcripts[0].Id;
				}
			}

		//search assigned pathes
		List<lmscons__Transcript_line__c> tlExPathes = new List<lmscons__Transcript_line__c>([select id, lmscons__Training_Content__c, lmscons__Training_Path_Item__r.lmscons__Training_Path__c from lmscons__Transcript_line__c where lmscons__Transcript__c=:trId and lmscons__training_path_item__c != null]);
		system.debug('\n tlExPathes: ' + tlExPathes);

		Set<Id> ExPathesIds = new Set<Id>();

		if(tlExPathes.size()>0){
			for(lmscons__Transcript_line__c tlcp : tlExPathes){
				ExPathesIds.add(tlcp.lmscons__Training_Path_Item__r.lmscons__Training_Path__c);
			}
		}

		system.debug('\n ExPathesIds: ' + ExPathesIds);

		List<Training_Path__c> AssignmentPathes = new List<Training_Path__c>([select Training_Path__c from Training_Path__c where OpportunityAssignment__c IN :oasIdsFinal and Training_Path__c not IN :ExPathesIds]);

		system.debug('\n AssignmentPathes: ' + AssignmentPathes);

		//remove dublicated path ids, selected from all OpportunityAssignment records
		Set<Id> FinalPathIds = new Set<Id>();
		for(Training_Path__c TCp : AssignmentPathes){
			if(FinalPathIds.contains(TCp.Training_Path__c) == false){
				FinalPathIds.add(TCp.Training_Path__c);
			}
		}

		system.debug('\n FinalPathIds: ' + FinalPathIds);

		if(FinalPathIds.size()>0){
			Set<Id> tcIds = new Set<Id>();
			map<Id, Id> TrPathItemIdandTrContentId = new map<Id, Id>();
			for(lmscons__Training_Path_Item__c tcId : [select id, lmscons__Training_Content__c from lmscons__Training_Path_Item__c where lmscons__Training_Path__c IN :FinalPathIds]){
				tcIds.add(tcId.lmscons__Training_Content__c);
				TrPathItemIdandTrContentId.put(tcId.id, tcId.lmscons__Training_Content__c);
			}

			system.debug('\n tcIds: ' + tcIds);

			//search ex training user lic for courses

			map<Id, Id> ExTrCourseandUserLicId= new map<Id, Id>();

			//get ex user licenses for course
			for(lmscons__Training_User_License__c tul : [select id,lmscons__Content_License__r.lmscons__Training_Content__c  from lmscons__Training_User_License__c where lmscons__Content_License__r.lmscons__Training_Content__c IN :tcIds and lmscons__User__c = :UserInfo.getUserId()]){

				system.debug('\n tulll: ' + tul);

				String tmpTul = tul.lmscons__Content_License__r.lmscons__Training_Content__c;

			// system.debug('\n tmpTul: ' + tmpTul);

				if(ExTrCourseandUserLicId.get(tmpTul) == null){
					ExTrCourseandUserLicId.put(tmpTul, tul.id);
				}

			}

			system.debug('\n ExTrCourseandUserLicId: ' + ExTrCourseandUserLicId);

			//set<Id> CourseIdsForUserLicId= new set<Id>();

			List<lmscons__Training_User_License__c> newuser_licenses = new List<lmscons__Training_User_License__c>();
			//create user license for courses
			for(Id i : tcIds){
				if(ExTrCourseandUserLicId.get(i) == null){
					newuser_licenses.add(new lmscons__Training_User_License__c(
						lmscons__User__c = UserInfo.getUserId(),
						lmscons__Content_License__c = [select id from lmscons__Training_Content_License__c where lmscons__training_content__c =:i order by CreatedDate limit 1].id
					));
				}
			}

			system.debug('\n newuser_licenses: ' + newuser_licenses);

			if(newuser_licenses.size()>0){
				insert newuser_licenses;

				Set<Id> nuIds = new Set<Id>();

				for(lmscons__Training_User_License__c nl : newuser_licenses){
					nuIds.add(nl.id);
				}

				system.debug('\n nuIds: ' + nuIds);

				if(nuIds.size()>0){
					for(lmscons__Training_User_License__c nul : [select id,lmscons__Content_License__r.lmscons__Training_Content__c  from lmscons__Training_User_License__c where id IN :nuIds and lmscons__User__c = :UserInfo.getUserId()]){

						system.debug('\n nulll: ' + nul.lmscons__Content_License__r.lmscons__Training_Content__c);

						if(ExTrCourseandUserLicId.get(nul.lmscons__Content_License__r.lmscons__Training_Content__c) == null){
							ExTrCourseandUserLicId.put(nul.lmscons__Content_License__r.lmscons__Training_Content__c, nul.id);
						}
					}
				}
			}


			system.debug('\n TrPathItemIdandTrContentId: ' + TrPathItemIdandTrContentId);

			for(Id i : TrPathItemIdandTrContentId.keySet()){

				system.debug('\n ExTrCourseandUserLicId.get(TrPathItemIdandTrContentId.get(i))1: ' + i);
				system.debug('\n ExTrCourseandUserLicId.get(TrPathItemIdandTrContentId.get(i))2: ' + TrPathItemIdandTrContentId.get(i));
				system.debug('\n ExTrCourseandUserLicId.get(TrPathItemIdandTrContentId.get(i))3: ' + ExTrCourseandUserLicId.get(TrPathItemIdandTrContentId.get(i)));

				tlpc.add(new lmscons__Transcript_Line__c(
					//lmscons__Training_Content__c =  [select lmscons__Training_Content__c from lmscons__Training_Content_License__c where id=:ul.lmscons__Content_License__c].lmscons__Training_Content__c,
					lmscons__Training_Path_Item__c = i,
					lmscons__Training_Content__c =  TrPathItemIdandTrContentId.get(i),
					lmscons__Transcript__c = trId,
					lmscons__Training_User_License__c = ExTrCourseandUserLicId.get(TrPathItemIdandTrContentId.get(i))
				));
			}

			if(tlpc.size() > 0){
				insert tlpc;
			}

			system.debug('\n tlpc: ' + tlpc);
			system.debug('\n Updated ExTrCourseandUserLicId: ' + ExTrCourseandUserLicId);

		}


		//search assigned courses
		List<lmscons__Transcript_line__c> tlExCourses = new List<lmscons__Transcript_line__c>([select id, lmscons__Training_Content__c from lmscons__Transcript_line__c where lmscons__Transcript__c=:trId and lmscons__training_path_item__c = null]);

		Set<Id> ExCoursesIds = new Set<Id>();

		if(tlExCourses.size()>0){
			for(lmscons__Transcript_line__c tlc2 : tlExCourses){
				ExCoursesIds.add(tlc2.lmscons__Training_Content__c);
			}
		}

		system.debug('\n ExCoursesIds: ' + ExCoursesIds);
		system.debug('\n oasIdsFinal: ' + oasIdsFinal);
		List<TrainingCourses__c> AssignmentCourses = new List<TrainingCourses__c>([select Training_Course__c from TrainingCourses__c where OpportunityAssignment__c IN :oasIdsFinal and Training_Course__c not IN :ExCoursesIds]);

		system.debug('\n AssignmentCourses: ' + AssignmentCourses);

		//remove dublicated course ids, selected from all OpportunityAssignment records
		Set<Id> FinalCoursesIds = new Set<Id>();
		for(TrainingCourses__c TC : AssignmentCourses){
			if(FinalCoursesIds.contains(TC.Training_Course__c) == false){
				FinalCoursesIds.add(TC.Training_Course__c);
			}
		}


		SYSTEM.DEBUG('XXXXX - FinalCoursesIds');

		if(FinalCoursesIds.size()>0){


			map<Id, Id> ExTrCourseandUserLicId2= new map<Id, Id>();

			//get ex user licenses for course
			for(lmscons__Training_User_License__c tul : [select id,lmscons__Content_License__r.lmscons__Training_Content__c  from lmscons__Training_User_License__c where lmscons__Content_License__r.lmscons__Training_Content__c IN :FinalCoursesIds and lmscons__User__c = :UserInfo.getUserId()]){

				String tmpTul = tul.lmscons__Content_License__r.lmscons__Training_Content__c;

				if(ExTrCourseandUserLicId2.get(tmpTul) == null){
					ExTrCourseandUserLicId2.put(tmpTul, tul.id);
				}

			}

			List<lmscons__Training_User_License__c> newuser_licenses2 = new List<lmscons__Training_User_License__c>();
			//create user license for courses
			for(Id i : FinalCoursesIds){
				if(ExTrCourseandUserLicId2.get(i) == null){
					newuser_licenses2.add(new lmscons__Training_User_License__c(
						lmscons__User__c = UserInfo.getUserId(),
						lmscons__Content_License__c = [select id from lmscons__Training_Content_License__c where lmscons__training_content__c =:i order by CreatedDate limit 1].id
					));
				}
			}

			if(newuser_licenses2.size()>0){
				insert newuser_licenses2;
				Set<Id> nuIds = new Set<Id>();

				for(lmscons__Training_User_License__c nl : newuser_licenses2){
					nuIds.add(nl.id);
				}

				system.debug('\n nuIds: ' + nuIds);

				if(nuIds.size()>0){
					for(lmscons__Training_User_License__c nul : [select id,lmscons__Content_License__r.lmscons__Training_Content__c  from lmscons__Training_User_License__c where id IN :nuIds]){

						system.debug('\n nulll: ' + nul.lmscons__Content_License__r.lmscons__Training_Content__c);

						if(ExTrCourseandUserLicId2.get(nul.lmscons__Content_License__r.lmscons__Training_Content__c) == null){
							ExTrCourseandUserLicId2.put(nul.lmscons__Content_License__r.lmscons__Training_Content__c, nul.id);
						}
					}
				}

			}

			system.debug('ExTrCourseandUserLicId2: '+ExTrCourseandUserLicId2);

			List<lmscons__Training_User_License__c> user_licenses = new List<lmscons__Training_User_License__c>([select lmscons__User__c, lmscons__Content_License__c, lmscons__Content_License__r.lmscons__Training_Content__c from lmscons__Training_User_License__c where id IN :ExTrCourseandUserLicId2.values()]);

			if(ExTrCourseandUserLicId2.size()>0){
				for(lmscons__Training_User_License__c ul : user_licenses){

					system.debug('\n ul: ' + ul);
					system.debug('\n ul.lmscons__Content_License__r: ' + ul.lmscons__Content_License__r.lmscons__Training_Content__c);

					tlc.add(new lmscons__Transcript_Line__c(
						//lmscons__Training_Content__c =  [select lmscons__Training_Content__c from lmscons__Training_Content_License__c where id=:ul.lmscons__Content_License__c].lmscons__Training_Content__c,
						lmscons__Training_Content__c =  ul.lmscons__Content_License__r.lmscons__Training_Content__c,
						lmscons__Transcript__c = trId,
						lmscons__Training_User_License__c = ul.id
					));
				}

				system.debug('\n tlc: ' + tlc);

				if(tlc.size()>0){
					insert tlc;
				}
			}
		}
	}

	//    /apex/lmscons__ConsumerDirector?action=LaunchContent&tuId={!M.MItem.lmscons__Training_User_License__c}

			String modulesIdsText = '';

			if(tlpc.size() > 0 || tlc.size()>0){

				List<FeedItem> FeedList = new List<FeedItem>();

				if(tlc.size()>0){
					Set<Id> tcIds = new Set<Id>();
					for(lmscons__Transcript_Line__c tl : tlc){
						tcIds.add(tl.lmscons__Training_Content__c);
					}
					Map<Id, lmscons__Training_Content__c> lTCc = new Map<Id, lmscons__Training_Content__c>([select Id, lmscons__Title__c from lmscons__Training_Content__c where id IN:tcIds]);
					for(lmscons__Transcript_Line__c tl : tlc){


						FeedItem fitem = new FeedItem();
						fitem.type = 'LinkPost';
						fitem.ParentId = ops[0].Id;
						fitem.Body = 'You\'ve been assigned the "'+lTCc.get(tl.lmscons__Training_Content__c).lmscons__Title__c+'" module in regards to the "'+ops[0].Name+'" opportunity:\n';
						fitem.LinkUrl = '/apex/lmscons__ConsumerDirector?action=LaunchContent&tuId='+tl.lmscons__Training_User_License__c;
						fitem.Title = 'Launch';
						FeedList.add(fitem);

						modulesIdsText = modulesIdsText + lTCc.get(tl.lmscons__Training_Content__c).Id + ',';

					}
				}

				Opportunity tuu = [SELECT Id, Training_Content_Ids__c FROM Opportunity WHERE Id = :ops[0].Id];
				if (tuu.Training_Content_Ids__c == null){
					tuu.Training_Content_Ids__c = modulesIdsText;
					update tuu;
				}

				if(tlpc.size()>0){
					Set<Id> tpIds = new Set<Id>();

					system.debug('tlpc: '+tlpc);

					for(lmscons__Transcript_Line__c tl : tlpc){
						tpIds.add(tl.lmscons__Training_Path_Item__c);
					}

					Map<Id, lmscons__Training_Path_Item__c > lTPc = new Map<Id, lmscons__Training_Path_Item__c >([select Id, lmscons__Training_Path__r.Name from lmscons__Training_Path_Item__c  where id IN:tpIds]);

					Set<String> tpNames = new Set<String>();

					for(lmscons__Transcript_Line__c tl : tlpc){
						if(tpNames.contains(lTPc.get(tl.lmscons__Training_Path_Item__c).lmscons__Training_Path__r.Name)==false){
							tpNames.add(lTPc.get(tl.lmscons__Training_Path_Item__c).lmscons__Training_Path__r.Name);

						/*
							FeedItem fitem = new FeedItem();
							fitem.type = 'LinkPost';
							fitem.ParentId = UserInfo.getUserId();
							fitem.Body = 'You\'ve been assigned the "'+lTPc.get(tl.lmscons__Training_Path_Item__c).lmscons__Training_Path__r.Name+'" course in regards to the "'+ops[0].Name+'" opportunity:\n';
							fitem.LinkUrl = Page.lmscons__MyTraining.getUrl();
							fitem.Title = 'Launch';
							FeedList.add(fitem);
						*/

							FeedItem fitem = new FeedItem();
							fitem.type = 'LinkPost';
							fitem.ParentId = ops[0].Id;
							fitem.Body = 'You\'ve been assigned the "'+lTPc.get(tl.lmscons__Training_Path_Item__c).lmscons__Training_Path__r.Name+'" course in regards to the "'+ops[0].Name+'" opportunity:\n';
							fitem.LinkUrl = Page.lmscons__MyTraining.getUrl();
							fitem.Title = 'Launch';
							FeedList.add(fitem);
						}
					}
				}

				List<EntitySubscription> f = [SELECT Id FROM EntitySubscription WHERE parentId = :ops[0].Id AND subscriberid = :UserInfo.getUserId()];
                if (f.size() == 0){
                   EntitySubscription follow = new EntitySubscription (parentId = ops[0].Id, subscriberid = UserInfo.getUserId());
                    insert follow;
                }

				insert FeedList;

				//FeedItem post = new FeedItem();
				//post.ParentId = UserInfo.getUserId();
				//post.Body = ChatterBody;
				//insert post;

			}

}
}