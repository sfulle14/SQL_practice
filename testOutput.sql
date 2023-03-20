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
