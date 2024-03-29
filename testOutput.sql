;WITH BOND_SETUP_cte AS
      (SELECT BSET.Case_Violation_Id
             ,CASE WHEN ISNULL(BSET.Bond_Value,0) > 0 THEN BSET.Bond_Value ELSE ISNULL(BSET.Bond_Fee,0) END BondAmount
             ,ROW_NUMBER() OVER(PARTITION BY BSET.Case_Violation_Id ORDER BY BSET.Date_Bond_Setup DESC) AS SeqNbr
         FROM BM_Source.dbo.Bond_Setups BSET WITH (NOLOCK))
UPDATE tblCaseCharge
SET
CaseID = C.CaseID
,SAOCaseNumber = ''
,OffenseDate = TCC.Date_Of_Violation
,ArrestDate = TCC.Date_Arrested
,ArrestingAgencyID = C.AgencyID
,ArrestingCaseNumber = C.CaseNumber
,OBTSNumber = ''
,CitationID = 0
,StatuteID = S.StatuteID
,ChargePhase = CASE WHEN ISNULL(TCD.Date_Of_Sentence,CS.Date_Of_Sentence) IS NOT NULL THEN 'C' ELSE 'I' END
,SetBondAmount = ISNULL(BS.BondAmount,0)
,InitialSequenceNumber = ISNULL(TRY_CONVERT(INT,CV.Counter),0)
,InitialStatuteID = S.StatuteID
,InitialChargeStatus = CASE WHEN TCC.Date_Arrested IS NOT NULL THEN 'F' WHEN ISNULL(TCC.Ticket_Number,'') > '' THEN 'CI' ELSE 'P' END
,InitialDrugType = ''
,InitialChargeWeapons = ''
,InitialChargeRange = ''
,InitialChargeAmount = 0
,InitialChargeUnit = ''
,InitialStatuteDescription = ISNULL(LTRIM(RTRIM(CV.Case_Violation_Description)),ISNULL(S.StatuteLongDescription,''))
,InitialChargeLevel = CASE ISNULL(SUBSTRING(LTRIM(RTRIM(DOV.Degree)),1,1),'') WHEN 'U' THEN 'F' ELSE ISNULL(SUBSTRING(LTRIM(RTRIM(DOV.Degree)),1,1),'') END
,InitialChargeDegree = ISNULL(LTRIM(RTRIM(DOV.Degree)),'')
,InitialGeneralOffenseCharacter = ''
,InitialOffenseActivity = ''
,ProsecutorSequenceNumber = ISNULL(TRY_CONVERT(INT,CV.Counter),0)
,ProsecutorStatuteID = 0
,ProsecutorChargeStatus = ''
,ProsecutorDrugType = ''
,ProsecutorChargeWeapons = ''
,ProsecutorChargeRange = ''
,ProsecutorChargeAmount = 0
,ProsecutorChargeUnit = ''
,ProsecutorFileDate = NULL
,ProsecutorFinalDecisionDate = NULL
,ProsecutorFinalAction = ''
,ProsecutorDefermentType = ''
,ProsecutorDefermentDate = NULL
,ProsecutorStatuteDescription = ''
,ProsecutorChargeLevel = ''
,ProsecutorChargeDegree = ''
,ProsecutorGeneralOffenseCharacter = ''
,ProsecutorOffenseActivity = ''
,CourtSequenceNumber = ISNULL(TRY_CONVERT(INT,CV.Counter),0)
,CourtStatuteID = SSNT.StatuteID
,CourtChargeStatus = CASE WHEN SSNT.StatuteID = S.StatuteID THEN 'S' ELSE '' END
,CourtDrugType = ''
,CourtChargeWeapons = ''
,CourtChargeRange = ''
,CourtChargeAmount = 0
,CourtChargeUnit = ''
,CourtDecisionDate = ISNULL(TCD.Date_Of_Sentence,CS.Date_Of_Sentence)
,CourtActionTaken = CASE WHEN ISNULL(LTRIM(RTRIM(SNT.Sentence_Code)),'') > '' THEN LTRIM(RTRIM(SNT.Sentence_Code)) ELSE CONVERT(VARCHAR(50),SNT.Sentence_Id) END
,CourtFinalPlea = LTRIM(RTRIM(PSNT.Plea_Code))
--,CourtFinalPlea = --,CONVERT(VARCHAR(50),PSNT.Plea_Id)
,CourtFinalPleaEnteredDate = ISNULL(TCD.Date_Final_Plea,CS.Date_Of_Sentence)
,CourtStatuteDescription = CASE WHEN SSNT.StatuteID = S.StatuteID THEN ISNULL(LTRIM(RTRIM(CV.Case_Violation_Description)),ISNULL(SSNT.StatuteLongDescription,'')) ELSE ISNULL(SSNT.StatuteLongDescription,'') END
,CourtChargeLevel = CASE ISNULL(SUBSTRING(LTRIM(RTRIM(DOVSNT.Degree)),1,1),'') WHEN 'U' THEN 'F' ELSE ISNULL(SUBSTRING(LTRIM(RTRIM(DOVSNT.Degree)),1,1),'') END
,CourtChargeDegree = ISNULL(LTRIM(RTRIM(DOVSNT.Degree)),'')
,CourtGeneralOffenseCharacter = ''
,CourtOffenseActivity = ''
,ReOpenDate = NULL
,ReOpenReason = ''
,ReOpenedChargeClosedDate = NULL
,AppealDate = NULL
,ArrestPartyNameID = 0
,DispositionPartyNameID = 0
,SentenceImposedDate = ISNULL(TCD.Date_Of_Sentence,CS.Date_Of_Sentence)
,SentenceEffectiveDate = ISNULL(TCD.Jail_From,CS.Jail_From)
,JudgeID = C.JudgeID
,JurisdictionRetained = 0
,SentenceStatus = 0
,SentenceStatusCaseNumber = ''
,SentenceStatusChargeCount = 0
,SentenceNotes = LEFT(ISNULL(LTRIM(RTRIM(CS.Comments)) + '   ','') + ISNULL(LTRIM(RTRIM(TCD.Suspension_Comments)),''),5000)
,CourtDocketNumber = ''
,MinConfinementCode = ''
,MaxConfinementCode = ''
,MinConfinementYears = 0
,MinConfinementMonths = 0
,MinConfinementDays = 0
,MaxConfinementYears = 0
,MaxConfinementMonths = 0
,MaxConfinementDays = CASE WHEN ISNULL(TCD.Total_Jail,0) > 0 THEN TCD.Total_Jail ELSE ISNULL(CS.Jail_Days,0) END
,OBTSMinConfinementYears = 0
,OBTSMinConfinementMonths = 0
,OBTSMinConfinementDays = 0
,OBTSMaxConfinementYears = 0
,OBTSMaxConfinementMonths = 0
,OBTSMaxConfinementDays = CASE WHEN ISNULL(TCD.Total_Jail,0) > 0 THEN TCD.Total_Jail ELSE ISNULL(CS.Jail_Days,0) END
,ConfinementTypeCode = CASE WHEN ISNULL(TCD.Total_Jail,0) > 0 THEN 'C' WHEN ISNULL(CS.Jail_Days,0) > 0 THEN 'C' ELSE '' END
,SuspendConfinementYears = 0
,SuspendConfinementMonths = 0
,SuspendConfinementDays = CASE WHEN ISNULL(TCD.Suspended_Jail,0) > 0 THEN TCD.Suspended_Jail ELSE ISNULL(CS.Jail_Days_Suspended,0) END
,OBTSSuspendConfinementYears = 0
,OBTSSuspendConfinementMonths = 0
,OBTSSuspendConfinementDays = 0
,CreditTimeServedCode = ''
,CreditTimeServedYears = 0
,CreditTimeServedMonths = 0
,CreditTimeServedDays = CASE WHEN ISNULL(TCD.Credit_Days,0) > 0 THEN TCD.Credit_Days ELSE ISNULL(CS.Jail_Days_In_Custody,0) END
,OBTSCreditTimeServedHours = 0
,ProbationTypeCode = ''
,ProbationLengthCode = ''
,ProbationLengthYears = 0
,ProbationLengthMonths = 0
,ProbationLengthDays = ISNULL(DATEDIFF(DAY,C.ProbationStartDate,C.ProbationEndDate),0)
,OBTSProbationLengthYears = 0
,OBTSProbationLengthMonths = 0
,OBTSProbationLengthDays = ISNULL(DATEDIFF(DAY,C.ProbationStartDate,C.ProbationEndDate),0)
,CommunityControlYears = 0
,CommunityControlMonths = 0
,CommunityControlDays = 0
,OBTSCommunityControlYears = 0
,OBTSCommunityControlMonths = 0
,OBTSCommunityControlDays = 0
,DLActionCode	  = CASE WHEN ISNULL(CS.License_Suspension_Days,0) > 0 THEN '1' END
--,DLActionCode  = --,CASE WHEN ISNULL(CS.License_Suspension_Days,0) > 0 THEN '1' WHEN ISNULL(CS.Driving_Privledges,0) > 0 THEN '2' ELSE '0' END
,LicenseSuspendedCode	 = L.Code
,LicenseSuspendedYears = 0
,LicenseSuspendedMonths = 0
,LicenseSuspendedDays = ISNULL(CS.License_Suspension_Days,0)
,LicenseReceivedByCourt = 0
,OBTSLicenseSuspendedYears = 0
,OBTSLicenseSuspendedMonths = 0
,OBTSLicenseSuspendedDays = ISNULL(CS.License_Suspension_Days,0)
,FineAmount = ISNULL(CS.Fine,0)
,CourtCostAmount = 0
,RestitutionAmount = ISNULL(CS.Restitution_Amount,0)
,SentenceProvision1 = ''
,SentenceProvision2 = ''
,SentenceProvision3 = ''
,SentenceProvision4 = ''
,SentenceProvision5 = ''
,SpecialSentenceProvision1 = ''
,SpecialSentenceProvision2 = ''
,SpecialSentenceProvision3 = ''
,SpecialSentenceProvision4 = ''
,SpecialSentenceProvision5 = ''
,SpecialSentenceProvision6 = ''
,SpecialSentenceProvision7 = ''
,DrugTraffickingTermYears = 0
,DrugTraffickingTermMonths = 0
,DrugTraffickingTermDays = 0
,OBTSDrugTraffickingTermYears = 0
,OBTSDrugTraffickingTermMonths = 0
,OBTSDrugTraffickingTermDays = 0
,CostOfSupervisionRate = 0
,CountyOfSupervision = 0
,CommunityServiceHours = ISNULL(CS.CS_Hours,0)
,RestitutionID = 0
,PlaintiffAttorneyID = 0
,DefendantAttorneyID = ISNULL(C.DefendantAttorneyID,0)
,TrialType = ''
,VerdictTypeCode = ''
,AppearanceTypeCode = ''
,DLRestrictedCode = ''
,LicenseRestrictedCode = ''
,LicenseRestrictedYears = 0
,LicenseRestrictedMonths = 0
,LicenseRestrictedDays = 0
,OBTSLicenseRestrictedYears = 0
,OBTSLicenseRestrictedMonths = 0
,OBTSLicenseRestrictedDays = 0
,FailureTermDays = 0
,FailureTermCreditTimeServed = 0
,GuidelinesWaived = 0
,DLReExam = 0
,IsDocketed = 0
,DocketSentencingChangesOnly = 0
,CaseProcessActionID = 0
,SentencingJudgeID = ISNULL(PJSNT.PartyID,0)
,Commitment = ''
,FollowedBy = ''
,JudicialWarning = 0
,AlternativeCourtSanction = 0
,NonJudicial = 0
,ImpoundmentVIN = ''
,ImpoundmentNoticeDate = NULL
,ImpoundmentPlateNumber = ''
,ImpoundmentVehicleYear = 0
,ImpoundmentVehicleMake = ''
,ImpoundmentVehicleModel = ''
,ImpoundmentVehicleColor = ''
,ImpoundmentDays = 0
,ImpoundmentOwnerID = 0
,ImpoundmentLienHolderID = 0
,VerdictDate = NULL
,IDISchool = 0
,ChildRestraintSchool = 0
,CreateByUserID = C.CreateByUserID
,CreateDate = C.CreateDate
,ModifyByUserID = C.ModifyByUserID
,ModifyDate = C.ModifyDate
,OBTSErrorMessages = ''
,DispositionJudgeID = ISNULL(PJSNT.PartyID,0)
,SentencingSchoolHours = 0
,DisposedByID = 0
,BookingNumber = ''
,RefNumber = CV.Case_Violation_Id
,CommunityControlLengthCode = ''
,ProbationStartDate = C.ProbationStartDate
,ConfinementStartDate = NULL
,WaivedAttorney = 0
,MandateDate = NULL
,AppealBondAmount = 0
,AmendedBondAmount = 0
,DirectFiling = 0
,RestitutionAmountSentencing = 0
,ComplaintNumber = ISNULL(LTRIM(RTRIM(TCC.Incident_Number)),'')
,ChargePoints		 = ISNULL(TCD.Points_Assessed,0)
--,ChargePoints = --,CASE WHEN ISNULL(TCD.Points_Assessed,0) > 0 THEN TCD.Points_Assessed ELSE ISNULL(CS.BMV_Points,0) END
,DLSuspensionStartDate = CS.License_Suspension_From
,DLSuspensionEndDate = CS.License_Suspension_To
,DLModifySuspensionStartDate = NULL
,DLModifySuspensionEndDate = NULL
,DLModificationCode = ''
,CourtStatuteModifiedReason = ''
,InitialEssentialFacts = ''
,ProsecutorEssentialFacts = ''
,CourtEssentialFacts = ''
,InitialEssentialFactID = 0
,ProsecutorEssentialFactID = 0
,CourtEssentialFactID = 0
,ProbationEndDate = C.ProbationEndDate
    FROM BM_Source.dbo.Case_Violations CV WITH (NOLOCK)
         INNER JOIN BM_Source.dbo.Traffic_Criminal_Cases TCC WITH (NOLOCK) ON TCC.Case_Number = CV.Case_Number
         INNER JOIN tblCase C WITH (NOLOCK) ON C.CaseNumber = CV.Case_Number
         LEFT OUTER JOIN BM_Source.dbo.Case_Sentences CS WITH (NOLOCK) ON CS.Case_Violation_Id = CV.Case_Violation_Id
         LEFT OUTER JOIN XREF_TRCR_Disposition TCD WITH (NOLOCK) ON TCD.Case_Violation_Id = CV.Case_Violation_Id AND TCD.SeqNbr = 1
         LEFT OUTER JOIN BM_Source.dbo.Pleas PSNT WITH (NOLOCK) ON PSNT.Plea_Id = ISNULL(TCD.Final_Plea_Id,CS.Plea_Id)
         LEFT OUTER JOIN BM_Source.dbo.Sentences SNT WITH (NOLOCK) ON SNT.Sentence_Id = ISNULL(TCD.Sentence_Id,CS.Sentence_Id)
         LEFT OUTER JOIN BM_Source.dbo.Violation_Codes VC WITH (NOLOCK) ON VC.violation_Id = CV.Violation_Id
         LEFT OUTER JOIN tblStatute S WITH (NOLOCK) ON S.StatuteNumber = VC.Section_Number	--GBDI-721: Citation Tab Issue - Not enabled on Cases w/Citation Records
         --LEFT OUTER JOIN tblStatute S WITH (NOLOCK) ON S.StatuteID = CV.Violation_Id		--GBDI-721: Citation Tab Issue - Not enabled on Cases w/Citation Records
         LEFT OUTER JOIN tblStatute SSNT WITH (NOLOCK) ON SSNT.StatuteNumber = VC.Section_Number   --GBDI-721: Citation Tab Issue - Not enabled on Cases w/Citation Records
         --LEFT OUTER JOIN tblStatute SSNT WITH (NOLOCK) ON SSNT.StatuteID = CS.Violation_Id	--GBDI-721: Citation Tab Issue - Not enabled on Cases w/Citation Records
         LEFT OUTER JOIN BM_Source.dbo.Degree_Of_Violations DOV WITH (NOLOCK) ON DOV.Degree_Of_Violation_Id = CV.Degree_Of_Violation_Id
         LEFT OUTER JOIN BM_Source.dbo.Degree_Of_Violations DOVSNT WITH (NOLOCK) ON DOVSNT.Degree_Of_Violation_Id = CS.Degree_Of_Violation_Id
         LEFT OUTER JOIN tblParty PJSNT WITH (NOLOCK) ON PJSNT.PrimaryPartyType = 'JDG' AND PJSNT.WebValidation = CONVERT(VARCHAR(255),ISNULL(TCD.Judge_Id,CS.Judge_Id))
         LEFT OUTER JOIN BOND_SETUP_cte BS WITH (NOLOCK) ON BS.Case_Violation_Id = CV.Case_Violation_Id AND BS.SeqNbr = 1
         LEFT OUTER JOIN BM_Source.dbo.Traffic_Criminal_Disposition LWTCD WITH (NOLOCK) ON LWTCD.Case_Violation_Id = TCD.Case_Violation_Id AND TCD.SeqNbr = 1 --GBDI-815:Map from dbo.Traffif_Criminal_Disposition the BMV_Susp_Class_Id to tblCaseCharge.LicenseSuspendedCode field
         LEFT OUTER JOIN tblLookup L WITH (NOLOCK) ON L.LookupGroup = 'LicenseSuspendedCode' AND L.LookupKey = LWTCD.BMV_Susp_Class_Id --GBDI-815:Map from dbo.Traffif_Criminal_Disposition the BMV_Susp_Class_Id to tblCaseCharge.LicenseSuspendedCode field
