USE portal_prototype
GO

-- Patients
CREATE TABLE Patients (
    PatientID          INT PRIMARY KEY,
    FirstName          VARCHAR(50),
    LastName           VARCHAR(50),
    Age                INT,
    Sex                VARCHAR(10),
    PreferredLanguage  VARCHAR(50),
    EnglishProficiency VARCHAR(20),   -- 'None', 'Low', 'Moderate', 'High'
    HealthLiteracyLvl  VARCHAR(20),   -- 'Low', 'Moderate', 'High'
    ChronicConditions  VARCHAR(255),  -- comma-separated for prototype
    MissedApptsLast12M INT
);
GO

-- Providers
CREATE TABLE Providers (
    ProviderID   INT PRIMARY KEY,
    ProviderName VARCHAR(100),
    Specialty    VARCHAR(100)
);
GO

-- Encounters
CREATE TABLE Encounters (
    EncounterID      INT PRIMARY KEY,
    PatientID        INT,
    ProviderID       INT,
    EncounterDate    DATE,
    VisitReason      VARCHAR(255),
    ProviderNotes    NVARCHAR(MAX),
    DiagnosisICD10   VARCHAR(20),
    Medications      VARCHAR(255),
    FollowUpRaw      NVARCHAR(MAX),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (ProviderID) REFERENCES Providers(ProviderID)
);
GO

-- ComprehensionLayer
CREATE TABLE ComprehensionLayer (
    EncounterID              INT PRIMARY KEY,
    SimplifiedSummary_EN     NVARCHAR(MAX),
    SimplifiedSummary_Lang   NVARCHAR(MAX),
    TargetLanguage           VARCHAR(50),
    MedInstructionsSimple    NVARCHAR(MAX),
    ReadingLevelGrade        DECIMAL(4,2), -- e.g. 4.5 grade level
    JargonDensityScore       DECIMAL(5,2), -- % of words flagged as jargon
    RiskFlag                 VARCHAR(20),  -- 'Low', 'Moderate', 'High'
    FOREIGN KEY (EncounterID) REFERENCES Encounters(EncounterID)
);
GO

-- JargonDictionary
CREATE TABLE JargonDictionary (
    TermID      INT PRIMARY KEY,
    JargonTerm  VARCHAR(100),
    Category    VARCHAR(50)  -- 'Medication', 'Condition', 'Procedure', etc.
);
GO

USE portal_prototype
GO

USE portal_prototype;
GO

INSERT INTO Patients
(PatientID, FirstName, LastName, Age, Sex, PreferredLanguage, EnglishProficiency,
 HealthLiteracyLvl, ChronicConditions, MissedApptsLast12M)
VALUES
(1, 'Maria', 'Silva', 54, 'F', 'Portuguese', 'Low', 'Low', 'Type 2 Diabetes, Hypertension', 3),
(2, 'Jose', 'Rodriguez', 47, 'M', 'Spanish', 'Moderate', 'Low', 'Asthma', 1),
(3, 'Ana', 'Costa', 38, 'F', 'Portuguese', 'High', 'Moderate', 'Major Depression', 0),
(4, 'Li', 'Wang', 62, 'M', 'Chinese', 'Low', 'Low', 'CHF, CKD Stage 3', 4),
(5, 'Fatima', 'Ali', 29, 'F', 'Arabic', 'Moderate', 'Moderate', 'Anxiety', 0),
(6, 'Samuel', 'Johnson', 71, 'M', 'English', 'High', 'Low', 'COPD', 2),
(7, 'Rosa', 'Martinez', 58, 'F', 'Spanish', 'Low', 'Low', 'Type 2 Diabetes', 5),
(8, 'Nguyen', 'Tran', 44, 'M', 'Vietnamese', 'Low', 'Low', 'Hypertension', 1),
(9, 'Amina', 'Hassan', 35, 'F', 'Arabic', 'Low', 'Moderate', 'Hypothyroidism', 0),
(10,'Carlos', 'Mendes', 52, 'M', 'Portuguese', 'Moderate', 'Low', 'Hyperlipidemia', 2),
(11,'Mei', 'Zhao', 33, 'F', 'Chinese', 'High', 'Moderate', 'PCOS', 0),
(12,'Omar', 'Said', 46, 'M', 'Arabic', 'Low', 'Low', 'Chronic Back Pain', 6),
(13,'Lucia', 'Santos', 60, 'F', 'Portuguese', 'Low', 'Low', 'Heart Disease', 3),
(14,'Daniel', 'Reyes', 41, 'M', 'Spanish', 'High', 'High', 'None', 0),
(15,'Sofia', 'Costa', 27, 'F', 'Portuguese', 'High', 'Moderate', 'Migraines', 0);
GO

INSERT INTO Providers
(ProviderID, ProviderName, Specialty)
VALUES
(1, 'Dr. Nguyen', 'Primary Care'),
(2, 'Dr. Thompson', 'Endocrinology'),
(3, 'Dr. Patel', 'Cardiology'),
(4, 'Dr. Rivera', 'Pulmonology'),
(5, 'Dr. Singh', 'Family Medicine');
GO

INSERT INTO Encounters
(EncounterID, PatientID, ProviderID, EncounterDate, VisitReason, ProviderNotes,
 DiagnosisICD10, Medications, FollowUpRaw)
VALUES
-- Maria Silva
(101, 1, 2, '2025-11-15', 'Diabetes follow-up',
 N'Patient exhibits suboptimal glycemic control with A1c trending upward. Recommended intensification of pharmacotherapy and adherence to low-carbohydrate diet.',
 'E11.9', 'Metformin 1000mg BID', N'Follow up in 3 months; repeat A1c.'),

(102, 1, 1, '2025-12-01', 'Hypertension check',
 N'Persistent hypertension despite monotherapy. Discussed initiation of combination therapy contingent on home BP monitoring.',
 'I10', 'Lisinopril 20mg QD', N'Check BP 3x/week; return in 1 month.'),

-- Jose Rodriguez
(103, 2, 1, '2025-11-20', 'Asthma exacerbation',
 N'Patient presents with wheezing and dyspnea. Initiated step-up therapy per GINA guidelines and reinforced inhaler technique.',
 'J45.909', 'Albuterol, Fluticasone', N'Follow up in 4 weeks.'),

(104, 2, 5, '2025-12-05', 'Medication review',
 N'Asthma symptoms remain poorly controlled likely due to suboptimal adherence. Provided comprehensive medication reconciliation.',
 'J45.909', 'Fluticasone BID', N'Return in 6 weeks.'),

-- Ana Costa
(105, 3, 5, '2025-11-10', 'Mental health follow-up',
 N'Patient demonstrates moderate depressive symptomatology. PHQ-9 score elevated. Recommended continuation of SSRI; discussed behavioral activation strategies.',
 'F33.1', 'Sertraline 50mg', N'Follow up in 2 months.'),

-- Li Wang
(106, 4, 3, '2025-11-28', 'Heart failure management',
 N'NYHA class III symptoms with progressive volume overload. Adjusted diuretics and emphasized sodium and fluid restriction.',
 'I50.9', 'Furosemide 40mg BID', N'Daily weights; call for sudden fluid gain.'),

(107, 4, 3, '2025-12-12', 'CHF follow-up',
 N'Patient continues to experience exertional dyspnea. Echocardiogram pending. Reinforced adherence to diuretic regimen.',
 'I50.9', 'Furosemide', N'Follow up after imaging.'),

-- Fatima Ali
(108, 5, 5, '2025-12-01', 'Anxiety check-in',
 N'Generalized anxiety persists. Discussed CBT referral and titration of SSRI. Patient verbalized partial insight.',
 'F41.1', 'Escitalopram 10mg', N'Return in 8 weeks.'),

-- Samuel Johnson
(109, 6, 4, '2025-11-18', 'COPD exacerbation',
 N'Evidence of acute bronchospasm; initiated corticosteroid burst and optimized bronchodilator regimen.',
 'J44.1', 'Prednisone, Albuterol', N'Follow up in 2 weeks.'),

(110, 6, 4, '2025-12-03', 'Pulmonary function review',
 N'Spirometry reveals persistent obstruction consistent with GOLD stage III. Encouraged smoking cessation.',
 'J44.9', 'Tiotropium', N'Follow up in 1 month.'),

-- Rosa Martinez
(111, 7, 2, '2025-10-30', 'Diabetes management',
 N'A1c remains elevated; patient demonstrates difficulty adhering to pharmacologic regimen. Discussed possible GLP-1 agonist.',
 'E11.65', 'Metformin, GLP-1 pending', N'Recheck A1c in 3 months.'),

(112, 7, 1, '2025-12-05', 'BP + glucose review',
 N'Multifactorial poor control suspected. Reinforced medication adherence and dietary modifications.',
 'I10', 'Lisinopril', N'Return in 6 weeks.'),

-- Nguyen Tran
(113, 8, 1, '2025-11-03', 'Hypertension follow-up',
 N'BP remains suboptimally controlled. Consideration of adding thiazide diuretic if next reading remains elevated.',
 'I10', 'Amlodipine', N'Recheck in 1 month.'),

-- Amina Hassan
(114, 9, 5, '2025-12-08', 'Thyroid follow-up',
 N'TSH trending downward; euthyroid state anticipated. Continue current levothyroxine dose.',
 'E03.9', 'Levothyroxine', N'Follow up in 3 months.'),

-- Carlos Mendes
(115, 10, 1, '2025-11-27', 'Cholesterol review',
 N'LDL remains above target threshold. Counseled on statin initiation pending shared decision-making.',
 'E78.5', 'Atorvastatin pending', N'Follow up in 2 months.'),

-- Mei Zhao
(116, 11, 5, '2025-12-10', 'PCOS management',
 N'Patient exhibits oligomenorrhea and insulin resistance; lifestyle modification emphasized. Metformin discussed.',
 'E28.2', 'Pending', N'Return in 3 months.'),

-- Omar Said
(117, 12, 1, '2025-11-15', 'Back pain flare',
 N'Chronic lumbar pain exacerbation. Ordered lumbar X-ray; advised conservative management and PT referral.',
 'M54.5', 'Ibuprofen PRN', N'Follow up after imaging.'),

(118, 12, 1, '2025-12-02', 'Pain follow-up',
 N'Pain persists; possible radiculopathy. Consider MRI if symptoms refractory to NSAIDs.',
 'M54.5', 'Ibuprofen PRN', N'Return in 4 weeks.'),

-- Lucia Santos
(119, 13, 3, '2025-12-01', 'Cardiac follow-up',
 N'Stable angina symptoms persist. Discussed potential need for stress test depending on symptom progression.',
 'I20.9', 'Nitroglycerin PRN', N'Return in 6 weeks.'),

-- Daniel Reyes
(120, 14, 1, '2025-10-22', 'General wellness',
 N'Patient asymptomatic; routine preventive care provided. Labs ordered.',
 'Z00.00', 'None', N'Annual follow up.'),

-- Sofia Costa
(121, 15, 5, '2025-12-09', 'Migraine evaluation',
 N'Migraine with aura noted. Recommended prophylactic therapy and avoidance of known triggers.',
 'G43.109', 'Sumatriptan PRN', N'Return in 8 weeks.'),

-- Extra encounters
(122, 1, 2, '2025-12-20', 'Diabetes education reinforcement',
 N'Patient requires reiteration of self-management strategies due to fluctuating glycemic patterns.',
 'E11.9', 'Metformin', N'Education follow-up in 4 weeks.'),

(123, 7, 2, '2025-11-18', 'Diet counseling',
 N'Extensive discussion on carbohydrate restriction and GLP-1 therapy. Patient comprehension uncertain.',
 'E11.9', 'Metformin', N'Follow up in 6 weeks.'),

(124, 4, 3, '2025-12-18', 'CHF medication adjustment',
 N'Continued volume overload; escalated diuretic therapy. Reinforced low-sodium diet.',
 'I50.9', 'Furosemide', N'Daily weights; call clinic PRN.'),

(125, 8, 5, '2025-12-11', 'Medication literacy check',
 N'Patient demonstrates limited understanding of antihypertensive therapy. Provided simplified instructions.',
 'I10', 'Amlodipine', N'Follow up in 1 month.');
GO

USE portal_prototype
GO

INSERT INTO ComprehensionLayer
(EncounterID, SimplifiedSummary_EN, SimplifiedSummary_Lang, TargetLanguage,
 MedInstructionsSimple, ReadingLevelGrade, JargonDensityScore, RiskFlag)
VALUES
(101,
 'Your blood sugar is higher than we want. We changed your medicine and need you to follow a low-sugar diet.',
 'O seu açúcar está mais alto do que queremos. Mudámos o medicamento e precisa seguir uma dieta com pouco açúcar.',
 'Portuguese',
 'Take Metformin twice a day with food. Avoid soda, bread, rice, and sweets.',
 5.3, 38.2, 'High'),

(102,
 'Your blood pressure is still high. We may change your treatment if home readings stay elevated.',
 'A sua pressão continua alta. Podemos mudar o tratamento se as leituras de casa continuarem elevadas.',
 'Portuguese',
 'Take Lisinopril once daily. Check your blood pressure three times a week.',
 4.7, 32.1, 'Moderate'),

(103,
 'You had trouble breathing today. We adjusted your inhalers to help you breathe better.',
 'Tuviste dificultad para respirar hoy. Ajustamos tus inhaladores para ayudarte a respirar mejor.',
 'Spanish',
 'Use Albuterol when needed. Use the Fluticasone every morning and night.',
 5.0, 35.4, 'Moderate'),

(104,
 'Your asthma is not controlled because the medicine is not taken regularly. We reviewed your medications.',
 'Tu asma no está controlada porque no tomas los medicamentos con regularidad. Revisamos tus medicinas.',
 'Spanish',
 'Use Fluticasone twice a day every day, not just when sick.',
 5.1, 30.2, 'Moderate'),

(105,
 'Your depression symptoms are still moderate. Continue your medication and try the activity plan we discussed.',
 'Os seus sintomas de depressão ainda são moderados. Continue a medicação e tente o plano de atividades que falámos.',
 'Portuguese',
 'Take Sertraline once a day. Try daily walks and small activities.',
 4.5, 25.1, 'Low'),

(106,
 'Your heart is holding extra fluid. We increased your water pill to help remove it.',
 'O seu coração está a reter líquido. Aumentámos o comprimido para tirar água.',
 'Portuguese',
 'Take Furosemide twice a day. Weigh yourself every morning.',
 6.0, 42.0, 'High'),

(107,
 'You are still having trouble breathing. Your heart test is coming soon. Keep taking your water pill.',
 'Ainda está com dificuldade para respirar. O exame ao coração está a chegar. Continue a tomar o comprimido de água.',
 'Portuguese',
 'Take Furosemide as prescribed every day.',
 5.8, 37.2, 'High'),

(108,
 'Your anxiety symptoms continue. We will slowly adjust your medication and recommend therapy.',
 '????? ????? ????? ????. ????? ???? ?????? ???????? ????? ???????.',
 'Arabic',
 'Take Escitalopram once daily. Practice slow breathing when anxious.',
 4.9, 28.0, 'Moderate'),

(109,
 'Your lungs were tight today. We gave you medicine to help open them.',
 'Your lungs were tight today. We gave you medicine to help open them.',
 'English',
 'Take Prednisone as directed. Use Albuterol when breathing is hard.',
 5.2, 29.1, 'Moderate'),

(110,
 'Your breathing test shows your lungs are still blocked. Keep taking your daily inhaler.',
 'Your breathing test shows your lungs are still blocked. Keep taking your daily inhaler.',
 'English',
 'Use Tiotropium once a day.',
 4.6, 23.5, 'Low'),

 (111,
 'Your sugar levels are still high. We may add a new medicine to help.',
 'Tus niveles de azúcar siguen altos. Podemos añadir un nuevo medicamento para ayudar.',
 'Spanish',
 'Take Metformin daily. We may start another injection soon.',
 5.2, 33.4, 'High'),

(112,
 'Your blood pressure and sugar are not well controlled. Please take your medicines every day.',
 'Su presión y azúcar no están bien controladas. Por favor tome sus medicinas todos los días.',
 'Spanish',
 'Take Lisinopril once daily. Bring your readings to your next visit.',
 5.0, 30.2, 'Moderate'),

(113,
 'Your blood pressure is still high. We may add another medicine next month.',
 'Huy?t áp c?a b?n v?n cao. Chúng tôi có th? thêm m?t lo?i thu?c khác vào tháng t?i.',
 'Vietnamese',
 'Take Amlodipine daily. Check blood pressure at home.',
 5.3, 28.9, 'Moderate'),

(114,
 'Your thyroid levels are getting better. Keep taking your same dose.',
 '??????? ????? ??????? ???? ?????. ????? ?? ??? ??????.',
 'Arabic',
 'Take Levothyroxine every morning on an empty stomach.',
 4.8, 20.2, 'Low'),

(115,
 'Your cholesterol is still high. We talked about starting a statin.',
 'O seu colesterol continua alto. Falámos sobre começar uma estatina.',
 'Portuguese',
 'If you choose to start Atorvastatin, take it once daily.',
 4.9, 26.1, 'Low'),

(116,
 'You may have hormone imbalance related to PCOS. Healthy eating and exercise will help.',
 'Pode ter um desequilíbrio hormonal relacionado com SOP. Alimentação saudável e exercício vão ajudar.',
 'Portuguese',
 'Follow a balanced diet and come back in 3 months.',
 4.8, 21.4, 'Low'),

(117,
 'Your back pain got worse. We ordered an X-ray and want you to try stretching and physical therapy.',
 '??? ???? ????? ?????. ????? ??????? ??????? ?????? ?? ???? ?????? ???????.',
 'Arabic',
 'Use Ibuprofen when needed. Start gentle stretching daily.',
 5.1, 29.2, 'Moderate'),

(118,
 'Your pain continues. You may need an MRI if it does not improve.',
 '?? ???? ????? ???????. ?? ????? ??? ????? ??????? ??? ?? ?????.',
 'Arabic',
 'Keep using Ibuprofen. Come back in 4 weeks.',
 5.0, 28.0, 'Moderate'),

(119,
 'Your chest pain is stable but needs watching. We may order a stress test soon.',
 'A sua dor no peito está estável mas precisa ser monitorizada. Podemos pedir um teste de esforço.',
 'Portuguese',
 'Use Nitroglycerin only during chest pain.',
 5.5, 34.5, 'Moderate'),

(120,
 'Everything looks normal today.',
 'Todo parece normal hoy.',
 'Spanish',
 'No medications needed.',
 3.8, 10.0, 'Low'),

(121,
 'Your migraines may be related to triggers. We will try a new treatment if needed.',
 'As suas enxaquecas podem estar ligadas a gatilhos. Vamos tentar um novo tratamento se for preciso.',
 'Portuguese',
 'Use Sumatriptan when migraine starts.',
 4.7, 22.3, 'Low'),

 (122,
 'We reviewed your diabetes plan again to help keep your sugar steady.',
 'Revimos o seu plano de diabetes novamente para ajudar a manter o açúcar estável.',
 'Portuguese',
 'Take Metformin as directed. Follow the diet plan.',
 5.1, 30.2, 'Moderate'),

(123,
 'We talked about cutting down on carbs and starting a new diabetes medicine.',
 'Hablamos sobre reducir los carbohidratos y empezar un nuevo medicamento.',
 'Spanish',
 'Take Metformin daily. Follow the food guidance.',
 5.0, 29.0, 'Moderate'),

(124,
 'You still have extra fluid. We increased your water pill.',
 'Ainda tem líquido extra. Aumentámos o comprimido de água.',
 'Portuguese',
 'Take Furosemide twice daily. Weigh yourself daily.',
 6.2, 40.0, 'High'),

(125,
 'We explained your blood pressure medicine again in simpler steps.',
 'Chúng tôi gi?i thích l?i thu?c huy?t áp c?a b?n b?ng các bu?c d? hi?u.',
 'Vietnamese',
 'Take Amlodipine daily. Bring your pill bottle next visit.',
 4.9, 25.1, 'Low');

 USE portal_prototype
 GO

 INSERT INTO JargonDictionary
(TermID, JargonTerm, Category)
VALUES
(1, 'glycemic control', 'Endocrine'),
(2, 'pharmacotherapy', 'Medication'),
(3, 'volume overload', 'Cardiology'),
(4, 'NYHA class III', 'Cardiology'),
(5, 'euthyroid', 'Endocrine'),
(6, 'exertional dyspnea', 'Cardiology'),
(7, 'bronchospasm', 'Pulmonology'),
(8, 'spirometry', 'Pulmonology'),
(9, 'GOLD stage III', 'Pulmonology'),
(10, 'suboptimal adherence', 'General'),
(11, 'medication reconciliation', 'General'),
(12, 'hyperlipidemia', 'Endocrine'),
(13, 'oligomenorrhea', 'Gynecology'),
(14, 'insulin resistance', 'Endocrine'),
(15, 'radiculopathy', 'Neurology'),
(16, 'tachycardia', 'Cardiology'),
(17, 'diuretic', 'Cardiology'),
(18, 'exacerbation', 'General'),
(19, 'elevated A1c', 'Endocrine'),
(20, 'GLP-1 agonist', 'Endocrine');

DELETE FROM ComprehensionLayer
WHERE TargetLanguage IN ('Arabic', 'Vietnamese')

DELETE FROM Encounters
WHERE EncounterID IN (108, 113, 114, 117, 118, 125)

DELETE FROM Patients
WHERE PatientID IN (5, 8, 9, 4, 11, 12);

SELECT * FROM dbo.ComprehensionLayer

SELECT * FROM dbo.Encounters

SELECT * FROM dbo.JargonDictionary

SELECT * FROM dbo.Patients

DELETE FROM Patients
WHERE PatientID IN (4, 11, 12);

DELETE FROM Encounters
WHERE EncounterID IN (110, 116);

DELETE FROM ComprehensionLayer
WHERE EncounterID IN (106,107,108,114,116,117,118,124);

DELETE FROM Encounters
WHERE EncounterID IN (106,107,108,114,116,117,118,124);

DELETE FROM Patients
WHERE PatientID IN (4,5,9,11,12);

SELECT * FROM Patients

SELECT * FROM Encounters

SELECT * FROM Providers

SELECT * FROM ComprehensionLayer

SELECT * FROM JargonDictionary;

GO

CREATE VIEW dbo.v_PatientRiskProfile
AS
SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.PreferredLanguage,
    p.EnglishProficiency,
    p.HealthLiteracyLvl,
    p.MissedApptsLast12M,
    e.EncounterID,
    e.EncounterDate,
    e.DiagnosisICD10,
    e.VisitReason,
    c.ReadingLevelGrade,
    c.JargonDensityScore,
    c.RiskFlag
FROM dbo.Patients p
JOIN dbo.Encounters e 
    ON p.PatientID = e.PatientID
JOIN dbo.ComprehensionLayer c 
    ON e.EncounterID = c.EncounterID;
GO

SELECT TOP 20 * 
FROM dbo.v_PatientRiskProfile;

CREATE DATABASE portal_prototype_v2;
GO

USE portal_prototype_v2;
GO

-- Patients (ONLY Spanish/English/Portuguese)
SET IDENTITY_INSERT dbo.Patients ON;
INSERT INTO dbo.Patients
(PatientID, FirstName, LastName, Age, Sex, PreferredLanguage, EnglishProficiency,
 HealthLiteracyLvl, ChronicConditions, MissedApptsLast12M)
VALUES
(1, 'Maria',  'Silva',    54, 'F', 'Portuguese', 'Low',      'Low',      'Type 2 Diabetes, Hypertension', 3),
(2, 'Jose',   'Rodriguez',47, 'M', 'Spanish',    'Moderate', 'Low',      'Asthma', 1),
(3, 'Ana',    'Costa',    38, 'F', 'Portuguese', 'High',     'Moderate', 'Major Depression', 0),
(6, 'Samuel', 'Johnson',  71, 'M', 'English',    'High',     'Low',      'COPD', 2),
(7, 'Rosa',   'Martinez', 58, 'F', 'Spanish',    'Low',      'Low',      'Type 2 Diabetes', 5),
(10,'Carlos', 'Mendes',   52, 'M', 'Portuguese', 'Moderate', 'Low',      'Hyperlipidemia', 2),
(13,'Lucia',  'Santos',   60, 'F', 'Portuguese', 'Low',      'Low',      'Heart Disease', 3),
(14,'Daniel', 'Reyes',    41, 'M', 'Spanish',    'High',     'High',     'None', 0),
(15,'Sofia',  'Costa',    27, 'F', 'Portuguese', 'High',     'Moderate', 'Migraines', 0);
SET IDENTITY_INSERT dbo.Patients OFF;
GO

-- Encounters (ONLY for Spanish/English/Portuguese patients)
SET IDENTITY_INSERT dbo.Encounters ON;
INSERT INTO dbo.Encounters
(EncounterID, PatientID, ProviderID, EncounterDate, VisitReason, ProviderNotes,
 DiagnosisICD10, Medications, FollowUpRaw)
VALUES
-- Maria Silva
(101, 1, 2, '2025-11-15', 'Diabetes follow-up',
 N'Patient exhibits suboptimal glycemic control with A1c trending upward. Recommended intensification of pharmacotherapy and adherence to low-carbohydrate diet.',
 'E11.9', 'Metformin 1000mg BID', N'Follow up in 3 months; repeat A1c.'),

(102, 1, 1, '2025-12-01', 'Hypertension check',
 N'Persistent hypertension despite monotherapy. Discussed initiation of combination therapy contingent on home BP monitoring.',
 'I10', 'Lisinopril 20mg QD', N'Check BP 3x/week; return in 1 month.'),

(122, 1, 2, '2025-12-20', 'Diabetes education reinforcement',
 N'Patient requires reiteration of self-management strategies due to fluctuating glycemic patterns.',
 'E11.9', 'Metformin', N'Education follow-up in 4 weeks.'),

-- Jose Rodriguez
(103, 2, 1, '2025-11-20', 'Asthma exacerbation',
 N'Patient presents with wheezing and dyspnea. Initiated step-up therapy per GINA guidelines and reinforced inhaler technique.',
 'J45.909', 'Albuterol, Fluticasone', N'Follow up in 4 weeks.'),

(104, 2, 5, '2025-12-05', 'Medication review',
 N'Asthma symptoms remain poorly controlled likely due to suboptimal adherence. Provided comprehensive medication reconciliation.',
 'J45.909', 'Fluticasone BID', N'Return in 6 weeks.'),

-- Ana Costa
(105, 3, 5, '2025-11-10', 'Mental health follow-up',
 N'Patient demonstrates moderate depressive symptomatology. PHQ-9 score elevated. Recommended continuation of SSRI; discussed behavioral activation strategies.',
 'F33.1', 'Sertraline 50mg', N'Follow up in 2 months.'),

-- Samuel Johnson
(109, 6, 4, '2025-11-18', 'COPD exacerbation',
 N'Evidence of acute bronchospasm; initiated corticosteroid burst and optimized bronchodilator regimen.',
 'J44.1', 'Prednisone, Albuterol', N'Follow up in 2 weeks.'),

(110, 6, 4, '2025-12-03', 'Pulmonary function review',
 N'Spirometry reveals persistent obstruction consistent with GOLD stage III. Encouraged smoking cessation.',
 'J44.9', 'Tiotropium', N'Follow up in 1 month.'),

-- Rosa Martinez
(111, 7, 2, '2025-10-30', 'Diabetes management',
 N'A1c remains elevated; patient demonstrates difficulty adhering to pharmacologic regimen. Discussed possible GLP-1 agonist.',
 'E11.65', 'Metformin, GLP-1 pending', N'Recheck A1c in 3 months.'),

(112, 7, 1, '2025-12-05', 'BP + glucose review',
 N'Multifactorial poor control suspected. Reinforced medication adherence and dietary modifications.',
 'I10', 'Lisinopril', N'Return in 6 weeks.'),

(123, 7, 2, '2025-11-18', 'Diet counseling',
 N'Extensive discussion on carbohydrate restriction and GLP-1 therapy. Patient comprehension uncertain.',
 'E11.9', 'Metformin', N'Follow up in 6 weeks.'),

-- Carlos Mendes
(115, 10, 1, '2025-11-27', 'Cholesterol review',
 N'LDL remains above target threshold. Counseled on statin initiation pending shared decision-making.',
 'E78.5', 'Atorvastatin pending', N'Follow up in 2 months.'),

-- Lucia Santos
(119, 13, 3, '2025-12-01', 'Cardiac follow-up',
 N'Stable angina symptoms persist. Discussed potential need for stress test depending on symptom progression.',
 'I20.9', 'Nitroglycerin PRN', N'Return in 6 weeks.'),

-- Daniel Reyes
(120, 14, 1, '2025-10-22', 'General wellness',
 N'Patient asymptomatic; routine preventive care provided. Labs ordered.',
 'Z00.00', 'None', N'Annual follow up.'),

-- Sofia Costa
(121, 15, 5, '2025-12-09', 'Migraine evaluation',
 N'Migraine with aura noted. Recommended prophylactic therapy and avoidance of known triggers.',
 'G43.109', 'Sumatriptan PRN', N'Return in 8 weeks.');
SET IDENTITY_INSERT dbo.Encounters OFF;
GO

-- ComprehensionLayer (ONLY matching the kept encounters)
INSERT INTO dbo.ComprehensionLayer
(EncounterID, SimplifiedSummary_EN, SimplifiedSummary_Lang, TargetLanguage,
 MedInstructionsSimple, ReadingLevelGrade, JargonDensityScore, RiskFlag)
VALUES
(101,'Your blood sugar is higher than we want. We changed your medicine and need you to follow a low-sugar diet.',
 'O seu açúcar está mais alto do que queremos. Mudámos o medicamento e precisa seguir uma dieta com pouco açúcar.',
 'Portuguese','Take Metformin twice a day with food. Avoid soda, bread, rice, and sweets.',5.3,38.2,'High'),

(102,'Your blood pressure is still high. We may change your treatment if home readings stay elevated.',
 'A sua pressão continua alta. Podemos mudar o tratamento se as leituras de casa continuarem elevadas.',
 'Portuguese','Take Lisinopril once daily. Check your blood pressure three times a week.',4.7,32.1,'Moderate'),

(103,'You had trouble breathing today. We adjusted your inhalers to help you breathe better.',
 'Tuviste dificultad para respirar hoy. Ajustamos tus inhaladores para ayudarte a respirar mejor.',
 'Spanish','Use Albuterol when needed. Use the Fluticasone every morning and night.',5.0,35.4,'Moderate'),

(104,'Your asthma is not controlled because the medicine is not taken regularly. We reviewed your medications.',
 'Tu asma no está controlada porque no tomas los medicamentos con regularidad. Revisamos tus medicinas.',
 'Spanish','Use Fluticasone twice a day every day, not just when sick.',5.1,30.2,'Moderate'),

(105,'Your depression symptoms are still moderate. Continue your medication and try the activity plan we discussed.',
 'Os seus sintomas de depressão ainda são moderados. Continue a medicação e tente o plano de atividades que falámos.',
 'Portuguese','Take Sertraline once a day. Try daily walks and small activities.',4.5,25.1,'Low'),

(109,'Your lungs were tight today. We gave you medicine to help open them.',
 'Your lungs were tight today. We gave you medicine to help open them.',
 'English','Take Prednisone as directed. Use Albuterol when breathing is hard.',5.2,29.1,'Moderate'),

(110,'Your breathing test shows your lungs are still blocked. Keep taking your daily inhaler.',
 'Your breathing test shows your lungs are still blocked. Keep taking your daily inhaler.',
 'English','Use Tiotropium once a day.',4.6,23.5,'Low'),

(111,'Your sugar levels are still high. We may add a new medicine to help.',
 'Tus niveles de azúcar siguen altos. Podemos añadir un nuevo medicamento para ayudar.',
 'Spanish','Take Metformin daily. We may start another injection soon.',5.2,33.4,'High'),

(112,'Your blood pressure and sugar are not well controlled. Please take your medicines every day.',
 'Su presión y azúcar no están bien controladas. Por favor tome sus medicinas todos los días.',
 'Spanish','Take Lisinopril once daily. Bring your readings to your next visit.',5.0,30.2,'Moderate'),

(115,'Your cholesterol is still high. We talked about starting a statin.',
 'O seu colesterol continua alto. Falámos sobre começar uma estatina.',
 'Portuguese','If you choose to start Atorvastatin, take it once daily.',4.9,26.1,'Low'),

(119,'Your chest pain is stable but needs watching. We may order a stress test soon.',
 'A sua dor no peito está estável mas precisa ser monitorizada. Podemos pedir um teste de esforço.',
 'Portuguese','Use Nitroglycerin only during chest pain.',5.5,34.5,'Moderate'),

(120,'Everything looks normal today.',
 'Todo parece normal hoy.',
 'Spanish','No medications needed.',3.8,10.0,'Low'),

(121,'Your migraines may be related to triggers. We will try a new treatment if needed.',
 'As suas enxaquecas podem estar ligadas a gatilhos. Vamos tentar um novo tratamento se for preciso.',
 'Portuguese','Use Sumatriptan when migraine starts.',4.7,22.3,'Low'),

(122,'We reviewed your diabetes plan again to help keep your sugar steady.',
 'Revimos o seu plano de diabetes novamente para ajudar a manter o açúcar estável.',
 'Portuguese','Take Metformin as directed. Follow the diet plan.',5.1,30.2,'Moderate'),

(123,'We talked about cutting down on carbs and starting a new diabetes medicine.',
 'Hablamos sobre reducir los carbohidratos y empezar un nuevo medicamento.',
 'Spanish','Take Metformin daily. Follow the food guidance.',5.0,29.0,'Moderate');
GO

USE portal_prototype_v2
/* =========================================================
   Portal Prototype V2
   Languages: English, Spanish, Portuguese ONLY
   ========================================================= */

IF DB_ID('portal_prototype_v2') IS NOT NULL
BEGIN
    ALTER DATABASE portal_prototype_v2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE portal_prototype_v2;
END;
GO

CREATE DATABASE portal_prototype_v2;
GO

USE portal_prototype_v2;
GO

/* ---------------------------
   Tables
--------------------------- */

CREATE TABLE dbo.Patients (
    PatientID          INT            NOT NULL PRIMARY KEY,
    FirstName          VARCHAR(50)    NOT NULL,
    LastName           VARCHAR(50)    NOT NULL,
    Age                INT            NULL,
    Sex                VARCHAR(10)    NULL,
    PreferredLanguage  VARCHAR(50)    NOT NULL,
    EnglishProficiency VARCHAR(20)    NULL,  -- 'None', 'Low', 'Moderate', 'High'
    HealthLiteracyLvl  VARCHAR(20)    NULL,  -- 'Low', 'Moderate', 'High'
    ChronicConditions  VARCHAR(255)   NULL,
    MissedApptsLast12M INT            NULL,
    CONSTRAINT CK_Patients_Language
        CHECK (PreferredLanguage IN ('English','Spanish','Portuguese'))
);
GO

CREATE TABLE dbo.Providers (
    ProviderID   INT           NOT NULL PRIMARY KEY,
    ProviderName VARCHAR(100)  NOT NULL,
    Specialty    VARCHAR(100)  NULL
);
GO

CREATE TABLE dbo.Encounters (
    EncounterID    INT            NOT NULL PRIMARY KEY,
    PatientID      INT            NOT NULL,
    ProviderID     INT            NOT NULL,
    EncounterDate  DATE           NOT NULL,
    VisitReason    VARCHAR(255)   NULL,
    ProviderNotes  NVARCHAR(MAX)  NULL,
    DiagnosisICD10 VARCHAR(20)    NULL,
    Medications    VARCHAR(255)   NULL,
    FollowUpRaw    NVARCHAR(MAX)  NULL,
    CONSTRAINT FK_Encounters_Patients
        FOREIGN KEY (PatientID) REFERENCES dbo.Patients(PatientID),
    CONSTRAINT FK_Encounters_Providers
        FOREIGN KEY (ProviderID) REFERENCES dbo.Providers(ProviderID)
);
GO

CREATE TABLE dbo.ComprehensionLayer (
    EncounterID           INT            NOT NULL PRIMARY KEY,
    SimplifiedSummary_EN  NVARCHAR(MAX)  NULL,
    SimplifiedSummary_Lang NVARCHAR(MAX) NULL,
    TargetLanguage        VARCHAR(50)    NOT NULL,
    MedInstructionsSimple NVARCHAR(MAX)  NULL,
    ReadingLevelGrade     DECIMAL(4,2)   NULL,
    JargonDensityScore    DECIMAL(5,2)   NULL,
    RiskFlag              VARCHAR(20)    NULL,  -- 'Low','Moderate','High'
    CONSTRAINT FK_Comprehension_Encounters
        FOREIGN KEY (EncounterID) REFERENCES dbo.Encounters(EncounterID),
    CONSTRAINT CK_Comprehension_TargetLanguage
        CHECK (TargetLanguage IN ('English','Spanish','Portuguese'))
);
GO

CREATE TABLE dbo.JargonDictionary (
    TermID      INT           NOT NULL PRIMARY KEY,
    JargonTerm  VARCHAR(100)  NOT NULL,
    Category    VARCHAR(50)   NULL
);
GO

/* ---------------------------
   Seed data: Patients
--------------------------- */

INSERT INTO dbo.Patients
(PatientID, FirstName, LastName, Age, Sex, PreferredLanguage, EnglishProficiency,
 HealthLiteracyLvl, ChronicConditions, MissedApptsLast12M)
VALUES
(1, 'Maria',  'Silva',    54, 'F', 'Portuguese', 'Low',      'Low',      'Type 2 Diabetes, Hypertension', 3),
(2, 'Jose',   'Rodriguez',47, 'M', 'Spanish',    'Moderate', 'Low',      'Asthma', 1),
(3, 'Ana',    'Costa',    38, 'F', 'Portuguese', 'High',     'Moderate', 'Major Depression', 0),
(6, 'Samuel', 'Johnson',  71, 'M', 'English',    'High',     'Low',      'COPD', 2),
(7, 'Rosa',   'Martinez', 58, 'F', 'Spanish',    'Low',      'Low',      'Type 2 Diabetes', 5),
(10,'Carlos', 'Mendes',   52, 'M', 'Portuguese', 'Moderate', 'Low',      'Hyperlipidemia', 2),
(13,'Lucia',  'Santos',   60, 'F', 'Portuguese', 'Low',      'Low',      'Heart Disease', 3),
(14,'Daniel', 'Reyes',    41, 'M', 'Spanish',    'High',     'High',     'None', 0),
(15,'Sofia',  'Costa',    27, 'F', 'Portuguese', 'High',     'Moderate', 'Migraines', 0);
GO

/* ---------------------------
   Seed data: Providers
--------------------------- */

INSERT INTO dbo.Providers
(ProviderID, ProviderName, Specialty)
VALUES
(1, 'Dr. Nguyen', 'Primary Care'),
(2, 'Dr. Thompson', 'Endocrinology'),
(3, 'Dr. Patel', 'Cardiology'),
(4, 'Dr. Rivera', 'Pulmonology'),
(5, 'Dr. Singh', 'Family Medicine');
GO

/* ---------------------------
   Seed data: Encounters
--------------------------- */

INSERT INTO dbo.Encounters
(EncounterID, PatientID, ProviderID, EncounterDate, VisitReason, ProviderNotes,
 DiagnosisICD10, Medications, FollowUpRaw)
VALUES
(101, 1, 2, '2025-11-15', 'Diabetes follow-up',
 N'Patient exhibits suboptimal glycemic control with A1c trending upward. Recommended intensification of pharmacotherapy and adherence to low-carbohydrate diet.',
 'E11.9', 'Metformin 1000mg BID', N'Follow up in 3 months; repeat A1c.'),

(102, 1, 1, '2025-12-01', 'Hypertension check',
 N'Persistent hypertension despite monotherapy. Discussed initiation of combination therapy contingent on home BP monitoring.',
 'I10', 'Lisinopril 20mg QD', N'Check BP 3x/week; return in 1 month.'),

(122, 1, 2, '2025-12-20', 'Diabetes education reinforcement',
 N'Patient requires reiteration of self-management strategies due to fluctuating glycemic patterns.',
 'E11.9', 'Metformin', N'Education follow-up in 4 weeks.'),

(103, 2, 1, '2025-11-20', 'Asthma exacerbation',
 N'Patient presents with wheezing and dyspnea. Initiated step-up therapy per GINA guidelines and reinforced inhaler technique.',
 'J45.909', 'Albuterol, Fluticasone', N'Follow up in 4 weeks.'),

(104, 2, 5, '2025-12-05', 'Medication review',
 N'Asthma symptoms remain poorly controlled likely due to suboptimal adherence. Provided comprehensive medication reconciliation.',
 'J45.909', 'Fluticasone BID', N'Return in 6 weeks.'),

(105, 3, 5, '2025-11-10', 'Mental health follow-up',
 N'Patient demonstrates moderate depressive symptomatology. PHQ-9 score elevated. Recommended continuation of SSRI; discussed behavioral activation strategies.',
 'F33.1', 'Sertraline 50mg', N'Follow up in 2 months.'),

(109, 6, 4, '2025-11-18', 'COPD exacerbation',
 N'Evidence of acute bronchospasm; initiated corticosteroid burst and optimized bronchodilator regimen.',
 'J44.1', 'Prednisone, Albuterol', N'Follow up in 2 weeks.'),

(110, 6, 4, '2025-12-03', 'Pulmonary function review',
 N'Spirometry reveals persistent obstruction consistent with GOLD stage III. Encouraged smoking cessation.',
 'J44.9', 'Tiotropium', N'Follow up in 1 month.'),

(111, 7, 2, '2025-10-30', 'Diabetes management',
 N'A1c remains elevated; patient demonstrates difficulty adhering to pharmacologic regimen. Discussed possible GLP-1 agonist.',
 'E11.65', 'Metformin, GLP-1 pending', N'Recheck A1c in 3 months.'),

(112, 7, 1, '2025-12-05', 'BP + glucose review',
 N'Multifactorial poor control suspected. Reinforced medication adherence and dietary modifications.',
 'I10', 'Lisinopril', N'Return in 6 weeks.'),

(123, 7, 2, '2025-11-18', 'Diet counseling',
 N'Extensive discussion on carbohydrate restriction and GLP-1 therapy. Patient comprehension uncertain.',
 'E11.9', 'Metformin', N'Follow up in 6 weeks.'),

(115, 10, 1, '2025-11-27', 'Cholesterol review',
 N'LDL remains above target threshold. Counseled on statin initiation pending shared decision-making.',
 'E78.5', 'Atorvastatin pending', N'Follow up in 2 months.'),

(119, 13, 3, '2025-12-01', 'Cardiac follow-up',
 N'Stable angina symptoms persist. Discussed potential need for stress test depending on symptom progression.',
 'I20.9', 'Nitroglycerin PRN', N'Return in 6 weeks.'),

(120, 14, 1, '2025-10-22', 'General wellness',
 N'Patient asymptomatic; routine preventive care provided. Labs ordered.',
 'Z00.00', 'None', N'Annual follow up.'),

(121, 15, 5, '2025-12-09', 'Migraine evaluation',
 N'Migraine with aura noted. Recommended prophylactic therapy and avoidance of known triggers.',
 'G43.109', 'Sumatriptan PRN', N'Return in 8 weeks.');
GO

/* ---------------------------
   Seed data: ComprehensionLayer
--------------------------- */

INSERT INTO dbo.ComprehensionLayer
(EncounterID, SimplifiedSummary_EN, SimplifiedSummary_Lang, TargetLanguage,
 MedInstructionsSimple, ReadingLevelGrade, JargonDensityScore, RiskFlag)
VALUES
(101,'Your blood sugar is higher than we want. We changed your medicine and need you to follow a low-sugar diet.',
 'O seu açúcar está mais alto do que queremos. Mudámos o medicamento e precisa seguir uma dieta com pouco açúcar.',
 'Portuguese','Take Metformin twice a day with food. Avoid soda, bread, rice, and sweets.',5.3,38.2,'High'),

(102,'Your blood pressure is still high. We may change your treatment if home readings stay elevated.',
 'A sua pressão continua alta. Podemos mudar o tratamento se as leituras de casa continuarem elevadas.',
 'Portuguese','Take Lisinopril once daily. Check your blood pressure three times a week.',4.7,32.1,'Moderate'),

(103,'You had trouble breathing today. We adjusted your inhalers to help you breathe better.',
 'Tuviste dificultad para respirar hoy. Ajustamos tus inhaladores para ayudarte a respirar mejor.',
 'Spanish','Use Albuterol when needed. Use the Fluticasone every morning and night.',5.0,35.4,'Moderate'),

(104,'Your asthma is not controlled because the medicine is not taken regularly. We reviewed your medications.',
 'Tu asma no está controlada porque no tomas los medicamentos con regularidad. Revisamos tus medicinas.',
 'Spanish','Use Fluticasone twice a day every day, not just when sick.',5.1,30.2,'Moderate'),

(105,'Your depression symptoms are still moderate. Continue your medication and try the activity plan we discussed.',
 'Os seus sintomas de depressão ainda são moderados. Continue a medicação e tente o plano de atividades que falámos.',
 'Portuguese','Take Sertraline once a day. Try daily walks and small activities.',4.5,25.1,'Low'),

(109,'Your lungs were tight today. We gave you medicine to help open them.',
 'Your lungs were tight today. We gave you medicine to help open them.',
 'English','Take Prednisone as directed. Use Albuterol when breathing is hard.',5.2,29.1,'Moderate'),

(110,'Your breathing test shows your lungs are still blocked. Keep taking your daily inhaler.',
 'Your breathing test shows your lungs are still blocked. Keep taking your daily inhaler.',
 'English','Use Tiotropium once a day.',4.6,23.5,'Low'),

(111,'Your sugar levels are still high. We may add a new medicine to help.',
 'Tus niveles de azúcar siguen altos. Podemos añadir un nuevo medicamento para ayudar.',
 'Spanish','Take Metformin daily. We may start another injection soon.',5.2,33.4,'High'),

(112,'Your blood pressure and sugar are not well controlled. Please take your medicines every day.',
 'Su presión y azúcar no están bien controladas. Por favor tome sus medicinas todos los días.',
 'Spanish','Take Lisinopril once daily. Bring your readings to your next visit.',5.0,30.2,'Moderate'),

(115,'Your cholesterol is still high. We talked about starting a statin.',
 'O seu colesterol continua alto. Falámos sobre começar uma estatina.',
 'Portuguese','If you choose to start Atorvastatin, take it once daily.',4.9,26.1,'Low'),

(119,'Your chest pain is stable but needs watching. We may order a stress test soon.',
 'A sua dor no peito está estável mas precisa ser monitorizada. Podemos pedir um teste de esforço.',
 'Portuguese','Use Nitroglycerin only during chest pain.',5.5,34.5,'Moderate'),

(120,'Everything looks normal today.',
 'Todo parece normal hoy.',
 'Spanish','No medications needed.',3.8,10.0,'Low'),

(121,'Your migraines may be related to triggers. We will try a new treatment if needed.',
 'As suas enxaquecas podem estar ligadas a gatilhos. Vamos tentar um novo tratamento se for preciso.',
 'Portuguese','Use Sumatriptan when migraine starts.',4.7,22.3,'Low'),

(122,'We reviewed your diabetes plan again to help keep your sugar steady.',
 'Revimos o seu plano de diabetes novamente para ajudar a manter o açúcar estável.',
 'Portuguese','Take Metformin as directed. Follow the diet plan.',5.1,30.2,'Moderate'),

(123,'We talked about cutting down on carbs and starting a new diabetes medicine.',
 'Hablamos sobre reducir los carbohidratos y empezar un nuevo medicamento.',
 'Spanish','Take Metformin daily. Follow the food guidance.',5.0,29.0,'Moderate');
GO

/* ---------------------------
   Seed data: JargonDictionary
--------------------------- */

INSERT INTO dbo.JargonDictionary
(TermID, JargonTerm, Category)
VALUES
(1, 'glycemic control', 'Endocrine'),
(2, 'pharmacotherapy', 'Medication'),
(3, 'volume overload', 'Cardiology'),
(4, 'NYHA class III', 'Cardiology'),
(5, 'euthyroid', 'Endocrine'),
(6, 'exertional dyspnea', 'Cardiology'),
(7, 'bronchospasm', 'Pulmonology'),
(8, 'spirometry', 'Pulmonology'),
(9, 'GOLD stage III', 'Pulmonology'),
(10, 'suboptimal adherence', 'General'),
(11, 'medication reconciliation', 'General'),
(12, 'hyperlipidemia', 'Endocrine'),
(13, 'oligomenorrhea', 'Gynecology'),
(14, 'insulin resistance', 'Endocrine'),
(15, 'radiculopathy', 'Neurology'),
(16, 'tachycardia', 'Cardiology'),
(17, 'diuretic', 'Cardiology'),
(18, 'exacerbation', 'General'),
(19, 'elevated A1c', 'Endocrine'),
(20, 'GLP-1 agonist', 'Endocrine');
GO

/* ---------------------------
   View: Patient Risk Profile
--------------------------- */

CREATE OR ALTER VIEW dbo.v_PatientRiskProfile
AS
SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    p.PreferredLanguage,
    p.EnglishProficiency,
    p.HealthLiteracyLvl,
    p.MissedApptsLast12M,
    e.EncounterID,
    e.EncounterDate,
    e.DiagnosisICD10,
    e.VisitReason,
    c.ReadingLevelGrade,
    c.JargonDensityScore,
    c.RiskFlag
FROM dbo.Patients p
JOIN dbo.Encounters e 
    ON p.PatientID = e.PatientID
JOIN dbo.ComprehensionLayer c 
    ON e.EncounterID = c.EncounterID;
GO

SELECT TOP 50 * FROM dbo.v_PatientRiskProfile ORDER BY EncounterDate DESC;
GO

SELECT TOP 5 * FROM dbo.ComprehensionLayer;

SELECT TOP 5 * FROM dbo.Encounters;

SELECT TOP 5 * from dbo.JargonDictionary;

SELECT TOP 5 * FROM dbo.Patients;

SELECT TOP 5 * FROM dbo.Providers;

ALTER TABLE dbo.ComprehensionLayer
ADD CONSTRAINT UQ_ComprehensionLayer_Encounter UNIQUE (EncounterID);

CREATE OR ALTER VIEW dbo.v_FollowUpWorklist AS
SELECT
  e.EncounterID,
  e.EncounterDate,
  p.PatientID,
  p.FirstName,
  p.LastName,
  p.PreferredLanguage,
  p.EnglishProficiency,
  p.HealthLiteracyLvl,
  e.DiagnosisICD10,
  e.Medications,
  e.FollowUpRaw,
  c.ReadingLevelGrade,
  c.JargonDensityScore,
  c.RiskFlag,
  pr.ProviderName,
  pr.Specialty
FROM dbo.Encounters e
JOIN dbo.Patients p ON p.PatientID = e.PatientID
JOIN dbo.Providers pr ON pr.ProviderID = e.ProviderID
LEFT JOIN dbo.ComprehensionLayer c ON c.EncounterID = e.EncounterID;

SELECT TOP 25 *
FROM dbo.v_FollowUpWorklist
ORDER BY EncounterDate DESC;

ALTER TABLE dbo.JargonDictionary
ADD PlainLanguageTerm VARCHAR(200) NULL,
    PlainDefinition  VARCHAR(500) NULL;

SELECT COUNT(*) AS OrphanEncounters
FROM dbo.Encounters e
LEFT JOIN dbo.Patients p ON p.PatientID = e.PatientID
WHERE p.PatientID IS NULL;

SELECT COUNT(*) AS OrphanEncounters
FROM dbo.Encounters e
LEFT JOIN dbo.Providers pr ON pr.ProviderID = e.ProviderID
WHERE pr.ProviderID IS NULL;

SELECT COUNT(*) AS EncountersMissingComprehension
FROM dbo.Encounters e
LEFT JOIN dbo.ComprehensionLayer c ON c.EncounterID = e.EncounterID
WHERE c.EncounterID IS NULL;

USE portal_prototype;
SELECT COUNT(*) FROM dbo.Encounters;

SELECT name
FROM sys.databases
ORDER BY name;

SELECT TOP 10 *
FROM dbo.Patients;

SELECT TOP 10 *
FROM dbo.Encounters
ORDER BY EncounterDate DESC;

SELECT
  EncounterID,
  VisitReason,
  CAST(ProviderNotes AS VARCHAR(MAX)) AS ProviderNotes
FROM dbo.Encounters
WHERE EncounterID = 122;

SELECT TOP 10
  EncounterID,
  VisitReason,
  SUBSTRING(CAST(ProviderNotes AS NVARCHAR(MAX)), 1, 350) + '…' AS ProviderNotes_Snippet
FROM dbo.Encounters
ORDER BY EncounterDate DESC;

SELECT TOP 10 * FROM dbo.ComprehensionLayer

SELECT TOP 10 * FROM dbo.JargonDictionary

SELECT TOP 10 * FROM dbo.Providers

-- 1) Use DB (brackets required because of hyphen)
USE [RCM-Analytics-Project];
GO

/* =======================
   2) Dimension Tables
   ======================= */

IF OBJECT_ID(N'dbo.Payers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Payers (
        PayerCanonical NVARCHAR(100) NOT NULL PRIMARY KEY,
        PlanType       NVARCHAR(50)  NULL
    );
END
GO

IF OBJECT_ID(N'dbo.Providers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Providers (
        ProviderID NVARCHAR(50)  NOT NULL PRIMARY KEY,
        NPI        NVARCHAR(20)  NULL,
        Specialty  NVARCHAR(100) NULL,
        Location   NVARCHAR(100) NULL
    );
END
GO

/* =======================
   3) Fact-ish Tables
   ======================= */

IF OBJECT_ID(N'dbo.Claims', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Claims (
        ClaimID        NVARCHAR(50)  NOT NULL PRIMARY KEY,
        PatientID      NVARCHAR(50)  NULL,
        ProviderID     NVARCHAR(50)  NULL,
        Location       NVARCHAR(100) NULL,
        Specialty      NVARCHAR(100) NULL,
        SubmitDate     DATE          NULL,
        Payer          NVARCHAR(150) NULL, -- raw payer label
        PayerCanonical NVARCHAR(100) NULL, -- normalized join field
        PlanType       NVARCHAR(50)  NULL,
        BilledAmount   DECIMAL(18,2) NULL,
        AllowedAmount  DECIMAL(18,2) NULL,
        ClaimStatus    NVARCHAR(50)  NULL
    );

    -- Optional FKs (add after load if you hit import issues)
    -- ALTER TABLE dbo.Claims
    -- ADD CONSTRAINT FK_Claims_Providers FOREIGN KEY (ProviderID) REFERENCES dbo.Providers(ProviderID);

    -- ALTER TABLE dbo.Claims
    -- ADD CONSTRAINT FK_Claims_Payers FOREIGN KEY (PayerCanonical) REFERENCES dbo.Payers(PayerCanonical);
END
GO

IF OBJECT_ID(N'dbo.Payments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Payments (
        PaymentID        NVARCHAR(50)  NOT NULL PRIMARY KEY,
        ClaimID          NVARCHAR(50)  NOT NULL,
        PaymentDate      DATE          NULL,
        PaymentAmount    DECIMAL(18,2) NULL,
        PaymentAmountRaw DECIMAL(18,2) NULL
    );

    -- Optional FK
    -- ALTER TABLE dbo.Payments
    -- ADD CONSTRAINT FK_Payments_Claims FOREIGN KEY (ClaimID) REFERENCES dbo.Claims(ClaimID);
END
GO

IF OBJECT_ID(N'dbo.Denials', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Denials (
        DenialID        NVARCHAR(50)  NOT NULL PRIMARY KEY,
        ClaimID         NVARCHAR(50)  NOT NULL,
        DenialDate      DATE          NULL,
        DenialCategory  NVARCHAR(100) NULL,
        AppealedFlag    BIT           NULL,
        ResubmittedFlag BIT           NULL,
        Outcome         NVARCHAR(50)  NULL
    );

    -- Optional FK
    -- ALTER TABLE dbo.Denials
    -- ADD CONSTRAINT FK_Denials_Claims FOREIGN KEY (ClaimID) REFERENCES dbo.Claims(ClaimID);
END
GO

/* =======================
   4) Indexes (safe create)
   ======================= */

-- Claims indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Claims_ProviderID' AND object_id = OBJECT_ID('dbo.Claims'))
    CREATE INDEX IX_Claims_ProviderID ON dbo.Claims(ProviderID);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Claims_PayerCanonical' AND object_id = OBJECT_ID('dbo.Claims'))
    CREATE INDEX IX_Claims_PayerCanonical ON dbo.Claims(PayerCanonical);

-- Payments index
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Payments_ClaimID' AND object_id = OBJECT_ID('dbo.Payments'))
    CREATE INDEX IX_Payments_ClaimID ON dbo.Payments(ClaimID);

-- Denials indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Denials_ClaimID' AND object_id = OBJECT_ID('dbo.Denials'))
    CREATE INDEX IX_Denials_ClaimID ON dbo.Denials(ClaimID);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Denials_Category' AND object_id = OBJECT_ID('dbo.Denials'))
    CREATE INDEX IX_Denials_Category ON dbo.Denials(DenialCategory);
GO

USE [RCM-Analytics-Project];

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

DROP TABLE Claims;

USE [RCM-Analytics-Project];
SELECT * FROM dbo.Claims

USE [RCM-Analytics-Project];
DROP TABLE Denials;
DROP TABLE Payers;
DROP TABLE Payments;
DROP TABLE Providers;

ALTER TABLE dbo.Claims
ADD ClaimKey INT IDENTITY(1,1) NOT NULL;

ALTER TABLE dbo.Claims
ADD CONSTRAINT PK_Claims_ClaimKey PRIMARY KEY (ClaimKey);

SELECT ClaimID, COUNT(*) AS cnt
FROM dbo.Claims
GROUP BY ClaimID
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

USE [RCM-Analytics-Project];

SELECT 'Claims'   AS table_name, COUNT(*) AS row_count FROM dbo.Claims
UNION ALL SELECT 'Payments', COUNT(*) FROM dbo.Payments
UNION ALL SELECT 'Denials',  COUNT(*) FROM dbo.Denials
UNION ALL SELECT 'Providers',COUNT(*) FROM dbo.Providers
UNION ALL SELECT 'Payers',   COUNT(*) FROM dbo.Payers;

SELECT TOP 5 * FROM dbo.Claims ORDER BY SubmitDate;
SELECT TOP 5 * FROM dbo.Payments ORDER BY PaymentDate;
SELECT TOP 5 * FROM dbo.Denials ORDER BY DenialDate;

SELECT TOP 5 ClaimKey, ClaimID, PatientID, ProviderID, PayerCanonical, BilledAmount, AllowedAmount
FROM dbo.Claims
ORDER BY ClaimKey;

USE [RCM-Analytics-Project];

-- A) Headline KPIs
SELECT
  SUM(c.BilledAmount) AS TotalBilled,
  COUNT(*)            AS ClaimCount,
  (SELECT SUM(p.PaymentAmount) FROM dbo.Payments p) AS TotalPayments,
  (SELECT COUNT(*) FROM dbo.Denials d) AS DenialEventCount,
  CAST((SELECT COUNT(DISTINCT d.ClaimID) FROM dbo.Denials d) AS float) / NULLIF(COUNT(*),0) AS DenialRate,
  CAST((SELECT SUM(p.PaymentAmount) FROM dbo.Payments p) AS float) / NULLIF(SUM(c.BilledAmount),0) AS CollectionsRate
FROM dbo.Claims c;

-- B) Denial Count by Payer (distinct claims denied)
SELECT
  c.PayerCanonical,
  COUNT(DISTINCT d.ClaimID) AS DeniedClaims
FROM dbo.Denials d
JOIN dbo.Claims c ON c.ClaimID = d.ClaimID
GROUP BY c.PayerCanonical
ORDER BY DeniedClaims DESC;

-- C) Denial Count by Category (events + distinct claims)
SELECT
  d.DenialCategory,
  COUNT(*) AS DenialEvents,
  COUNT(DISTINCT d.ClaimID) AS DeniedClaims
FROM dbo.Denials d
GROUP BY d.DenialCategory
ORDER BY DeniedClaims DESC;

-- D) Denial Count by Outcome
SELECT
  d.Outcome,
  COUNT(*) AS DenialEvents
FROM dbo.Denials d
GROUP BY d.Outcome
ORDER BY DenialEvents DESC;

-- E) Resubmitted Denials per Month (your line chart)
SELECT
  DATENAME(MONTH, d.DenialDate) AS MonthName,
  MONTH(d.DenialDate)           AS MonthNum,
  COUNT(*) AS ResubmittedDenials
FROM dbo.Denials d
WHERE d.ResubmittedFlag = 1
GROUP BY DATENAME(MONTH, d.DenialDate), MONTH(d.DenialDate)
ORDER BY MonthNum;

USE [RCM-Analytics-Project];

CREATE VIEW dbo.v_KPI_Summary AS
SELECT
  SUM(c.BilledAmount) AS TotalBilled,
  COUNT(*)            AS ClaimCount,
  (SELECT SUM(p.PaymentAmount) FROM dbo.Payments p) AS TotalPayments,
  (SELECT COUNT(*) FROM dbo.Denials d) AS DenialEventCount,
  CAST((SELECT COUNT(DISTINCT d.ClaimID) FROM dbo.Denials d) AS float) / NULLIF(COUNT(*),0) AS DenialRate,
  CAST((SELECT SUM(p.PaymentAmount) FROM dbo.Payments p) AS float) / NULLIF(SUM(c.BilledAmount),0) AS CollectionsRate
FROM dbo.Claims c;
GO

CREATE OR ALTER VIEW dbo.v_Denials_By_Payer AS
SELECT
  c.PayerCanonical,
  COUNT(DISTINCT d.ClaimID) AS DeniedClaims
FROM dbo.Denials d
JOIN dbo.Claims c ON c.ClaimID = d.ClaimID
GROUP BY c.PayerCanonical;
GO

CREATE OR ALTER VIEW dbo.v_Denials_By_Category AS
SELECT
  d.DenialCategory,
  COUNT(*) AS DenialEvents,
  COUNT(DISTINCT d.ClaimID) AS DeniedClaims
FROM dbo.Denials d
GROUP BY d.DenialCategory;
GO

CREATE OR ALTER VIEW dbo.v_Denials_By_Outcome AS
SELECT
  d.Outcome,
  COUNT(*) AS DenialEvents
FROM dbo.Denials d
GROUP BY d.Outcome;
GO

CREATE OR ALTER VIEW dbo.v_Resubmitted_Denials_Monthly AS
SELECT
  YEAR(d.DenialDate) AS [Year],
  MONTH(d.DenialDate) AS [Month],
  COUNT(*) AS ResubmittedDenials
FROM dbo.Denials d
WHERE d.ResubmittedFlag = 1
GROUP BY YEAR(d.DenialDate), MONTH(d.DenialDate);
GO

-- Denials that don't match a claim
SELECT COUNT(*) AS OrphanDenials
FROM dbo.Denials d
LEFT JOIN dbo.Claims c ON c.ClaimID = d.ClaimID
WHERE c.ClaimID IS NULL;

-- Payments that don't match a claim
SELECT COUNT(*) AS OrphanPayments
FROM dbo.Payments p
LEFT JOIN dbo.Claims c ON c.ClaimID = p.ClaimID
WHERE c.ClaimID IS NULL;

SELECT
  CAST(SUM(CASE WHEN d.ClaimID IS NULL THEN 1 ELSE 0 END) AS float) / COUNT(*) AS CleanClaimRate
FROM dbo.Claims c
LEFT JOIN (SELECT DISTINCT ClaimID FROM dbo.Denials) d
  ON c.ClaimID = d.ClaimID;