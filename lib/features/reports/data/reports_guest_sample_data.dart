import 'package:dr_swift_diagnostics/features/reports/data/models/report_models.dart';

/// Guest (G1) multi-member sample reports — My Health / Mom / Dad, by test date.
const guestFamilyMemberReports = [
  GuestFamilyMemberReport(
    memberName: 'My Health',
    datedReports: [
      GuestDatedReport(
        daysAgo: 1,
        results: _myHealthResultsNov2025,
        heartHealthTrend: ReportHeartHealthTrend(
          title: 'Heart Health',
          subtitle: 'LDL Cholesterol trend',
          labelDaysAgo: [150, 78, 1],
          values: [172, 148, 135],
          unit: 'mg/dL',
        ),
        healthIndicators: _myHealthIndicatorsNov2025,
        interpretations: _myHealthInterpretationsNov2025,
      ),
      GuestDatedReport(
        daysAgo: 78,
        results: _myHealthResultsSep2024,
        heartHealthTrend: ReportHeartHealthTrend(
          title: 'Heart Health',
          subtitle: 'LDL Cholesterol trend',
          labelDaysAgo: [200, 130, 78],
          values: [195, 182, 172],
          unit: 'mg/dL',
        ),
        healthIndicators: _myHealthIndicatorsSep2024,
        interpretations: _myHealthInterpretationsSep2024,
      ),
    ],
  ),
  GuestFamilyMemberReport(
    memberName: 'Mom',
    datedReports: [
      GuestDatedReport(
        daysAgo: 1,
        results: _momResultsNov2025,
        heartHealthTrend: ReportHeartHealthTrend(
          title: 'Blood Health',
          subtitle: 'Hemoglobin trend',
          labelDaysAgo: [120, 60, 1],
          values: [11.4, 10.9, 10.5],
          unit: 'g/dL',
        ),
        healthIndicators: _momIndicatorsNov2025,
        interpretations: _momInterpretationsNov2025,
      ),
      GuestDatedReport(
        daysAgo: 78,
        results: _momResultsSep2024,
        heartHealthTrend: ReportHeartHealthTrend(
          title: 'Blood Health',
          subtitle: 'Hemoglobin trend',
          labelDaysAgo: [200, 130, 78],
          values: [12.0, 11.7, 11.4],
          unit: 'g/dL',
        ),
        healthIndicators: _momIndicatorsSep2024,
        interpretations: _momInterpretationsSep2024,
      ),
    ],
  ),
  GuestFamilyMemberReport(
    memberName: 'Dad',
    datedReports: [
      GuestDatedReport(
        daysAgo: 1,
        results: _dadResultsNov2025,
        heartHealthTrend: ReportHeartHealthTrend(
          title: 'Heart Health',
          subtitle: 'Total Cholesterol trend',
          labelDaysAgo: [150, 78, 1],
          values: [210, 220, 228],
          unit: 'mg/dL',
        ),
        healthIndicators: _dadIndicatorsNov2025,
        interpretations: _dadInterpretationsNov2025,
      ),
      GuestDatedReport(
        daysAgo: 78,
        results: _dadResultsSep2024,
        heartHealthTrend: ReportHeartHealthTrend(
          title: 'Heart Health',
          subtitle: 'Total Cholesterol trend',
          labelDaysAgo: [200, 130, 78],
          values: [198, 204, 210],
          unit: 'mg/dL',
        ),
        healthIndicators: _dadIndicatorsSep2024,
        interpretations: _dadInterpretationsSep2024,
      ),
    ],
  ),
];

const _myHealthResultsNov2025 = [
  ReportResultRow(
    testName: 'Hemoglobin A1c',
    currentValue: '5.2',
    past1Value: '5.6',
    past2Value: '5.8',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Glucose',
    currentValue: '78',
    past1Value: '89',
    past2Value: '92',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Cholesterol, Total',
    currentValue: '184',
    past1Value: '248',
    past2Value: '255',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'LDL Cholesterol',
    currentValue: '135',
    past1Value: '172',
    past2Value: '180',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'HDL Cholesterol',
    currentValue: '35',
    past1Value: '48',
    past2Value: '46',
    flag: ReportResultFlag.borderline,
  ),
  ReportResultRow(
    testName: 'Vitamin D, 25-Hydroxy',
    currentValue: '17.3',
    past1Value: '11.1',
    past2Value: '9.8',
    flag: ReportResultFlag.low,
  ),
  ReportResultRow(
    testName: 'TSH',
    currentValue: '2.21',
    past1Value: '1.42',
    past2Value: '1.35',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Hemoglobin',
    currentValue: '14.3',
    past1Value: '14.1',
    past2Value: '13.9',
    flag: ReportResultFlag.healthy,
  ),
];

const _myHealthResultsSep2024 = [
  ReportResultRow(
    testName: 'Hemoglobin A1c',
    currentValue: '5.6',
    past1Value: '5.8',
    past2Value: '6.0',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Glucose',
    currentValue: '89',
    past1Value: '92',
    past2Value: '95',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Cholesterol, Total',
    currentValue: '248',
    past1Value: '255',
    past2Value: '262',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'LDL Cholesterol',
    currentValue: '172',
    past1Value: '180',
    past2Value: '188',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'HDL Cholesterol',
    currentValue: '48',
    past1Value: '46',
    past2Value: '44',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Vitamin D, 25-Hydroxy',
    currentValue: '11.1',
    past1Value: '9.8',
    past2Value: '8.5',
    flag: ReportResultFlag.low,
  ),
];

const _momResultsNov2025 = [
  ReportResultRow(
    testName: 'Hemoglobin',
    currentValue: '10.5',
    past1Value: '11.4',
    past2Value: '11.8',
    flag: ReportResultFlag.low,
  ),
  ReportResultRow(
    testName: 'Vitamin B12',
    currentValue: '180',
    past1Value: '210',
    past2Value: '225',
    flag: ReportResultFlag.low,
  ),
  ReportResultRow(
    testName: 'Iron',
    currentValue: '45',
    past1Value: '58',
    past2Value: '62',
    flag: ReportResultFlag.low,
  ),
  ReportResultRow(
    testName: 'TSH',
    currentValue: '2.1',
    past1Value: '2.5',
    past2Value: '2.4',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Calcium',
    currentValue: '9.2',
    past1Value: '8.9',
    past2Value: '8.7',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Glucose',
    currentValue: '92',
    past1Value: '88',
    past2Value: '86',
    flag: ReportResultFlag.healthy,
  ),
];

const _momResultsSep2024 = [
  ReportResultRow(
    testName: 'Hemoglobin',
    currentValue: '11.4',
    past1Value: '11.8',
    past2Value: '12.0',
    flag: ReportResultFlag.low,
  ),
  ReportResultRow(
    testName: 'Vitamin B12',
    currentValue: '210',
    past1Value: '225',
    past2Value: '240',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Iron',
    currentValue: '58',
    past1Value: '62',
    past2Value: '65',
    flag: ReportResultFlag.borderline,
  ),
  ReportResultRow(
    testName: 'TSH',
    currentValue: '2.5',
    past1Value: '2.4',
    past2Value: '2.3',
    flag: ReportResultFlag.healthy,
  ),
];

const _dadResultsNov2025 = [
  ReportResultRow(
    testName: 'HbA1c',
    currentValue: '7.2',
    past1Value: '6.8',
    past2Value: '6.5',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'Cholesterol, Total',
    currentValue: '228',
    past1Value: '210',
    past2Value: '205',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'LDL Cholesterol',
    currentValue: '148',
    past1Value: '135',
    past2Value: '128',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'Creatinine',
    currentValue: '1.0',
    past1Value: '0.89',
    past2Value: '0.85',
    flag: ReportResultFlag.healthy,
  ),
  ReportResultRow(
    testName: 'Vitamin D',
    currentValue: '22',
    past1Value: '28',
    past2Value: '24',
    flag: ReportResultFlag.low,
  ),
  ReportResultRow(
    testName: 'eGFR',
    currentValue: '88',
    past1Value: '92',
    past2Value: '94',
    flag: ReportResultFlag.healthy,
  ),
];

const _dadResultsSep2024 = [
  ReportResultRow(
    testName: 'HbA1c',
    currentValue: '6.8',
    past1Value: '6.5',
    past2Value: '6.2',
    flag: ReportResultFlag.borderline,
  ),
  ReportResultRow(
    testName: 'Cholesterol, Total',
    currentValue: '210',
    past1Value: '205',
    past2Value: '198',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'LDL Cholesterol',
    currentValue: '135',
    past1Value: '128',
    past2Value: '122',
    flag: ReportResultFlag.veryHigh,
  ),
  ReportResultRow(
    testName: 'Vitamin D',
    currentValue: '28',
    past1Value: '24',
    past2Value: '20',
    flag: ReportResultFlag.borderline,
  ),
];

const _myHealthIndicatorsNov2025 = [
  ReportHealthIndicator(
    condition: 'High Cholesterol (Dyslipidemia)',
    symptoms:
        'Often symptom-free. May present as chest heaviness or breathlessness on stairs.',
    labResult: 'Cholesterol 184 · LDL 135 mg/dL',
  ),
  ReportHealthIndicator(
    condition: 'Vitamin D Deficiency',
    symptoms:
        'Bone pain, muscle weakness, frequent infections, depression, hair fall.',
    labResult: 'Vit D: 17.3 ng/mL — Low',
  ),
  ReportHealthIndicator(
    condition: 'Borderline HDL',
    symptoms:
        'Usually no symptoms. Low HDL raises long-term heart disease risk.',
    labResult: 'HDL: 35 mg/dL — Below 40',
  ),
];

const _myHealthIndicatorsSep2024 = [
  ReportHealthIndicator(
    condition: 'High Cholesterol (Dyslipidemia)',
    symptoms:
        'Often symptom-free. May present as chest heaviness or breathlessness on stairs.',
    labResult: 'Cholesterol 248 · LDL 172 mg/dL',
  ),
  ReportHealthIndicator(
    condition: 'Vitamin D Deficiency',
    symptoms:
        'Bone pain, muscle weakness, frequent infections, depression, hair fall.',
    labResult: 'Vit D: 11.1 ng/mL — Low',
  ),
];

const _momIndicatorsNov2025 = [
  ReportHealthIndicator(
    condition: 'Mild Anaemia (Low Hemoglobin)',
    symptoms:
        'Pallor, fatigue on minimal activity, breathlessness, dizziness, cold hands and feet.',
    labResult: 'Hb: 10.5 g/dL — Low',
  ),
  ReportHealthIndicator(
    condition: 'Vitamin B12 Deficiency',
    symptoms:
        'Tingling in hands/feet, memory issues, fatigue, pale skin, glossitis.',
    labResult: 'B12: 180 pg/mL — Low',
  ),
  ReportHealthIndicator(
    condition: 'Low Iron',
    symptoms:
        'Brittle nails, restless legs, craving ice, hair thinning, low energy.',
    labResult: 'Iron: 45 µg/dL — Low',
  ),
];

const _momIndicatorsSep2024 = [
  ReportHealthIndicator(
    condition: 'Borderline Low Hemoglobin',
    symptoms:
        'Mild fatigue, occasional breathlessness on exertion.',
    labResult: 'Hb: 11.4 g/dL — Borderline',
  ),
];

const _dadIndicatorsNov2025 = [
  ReportHealthIndicator(
    condition: 'Pre-Diabetes / High Blood Sugar',
    symptoms:
        'Frequent thirst, urinating often, fatigue after meals, slow-healing wounds.',
    labResult: 'HbA1c: 7.2% — High',
  ),
  ReportHealthIndicator(
    condition: 'High Cholesterol (Dyslipidemia)',
    symptoms:
        'Often symptom-free. May present as chest heaviness or breathlessness on exertion.',
    labResult: 'Cholesterol 228 · LDL 148 mg/dL',
  ),
  ReportHealthIndicator(
    condition: 'Vitamin D Deficiency',
    symptoms:
        'Bone pain, muscle weakness, lower back pain, frequent infections.',
    labResult: 'Vit D: 22 ng/mL — Low',
  ),
];

const _dadIndicatorsSep2024 = [
  ReportHealthIndicator(
    condition: 'Elevated Cholesterol',
    symptoms: 'Often symptom-free at this stage.',
    labResult: 'Cholesterol 210 · LDL 135 mg/dL',
  ),
  ReportHealthIndicator(
    condition: 'Borderline HbA1c',
    symptoms: 'May include fatigue after meals.',
    labResult: 'HbA1c: 6.8% — Borderline',
  ),
];

const _myHealthInterpretationsNov2025 = [
  ReportInterpretation(
    title: 'LDL CHOLESTEROL — 135 MG/DL',
    flagLabel: 'HIGH',
    flag: ReportResultFlag.veryHigh,
    whatThisTests:
        'LDL is "bad" cholesterol that builds up in arteries causing blockages.',
    doctorInterpretation:
        '135 mg/dL is above the optimal target (<100 mg/dL). Dietary changes and follow-up lipid panel in 3 months are recommended.',
  ),
  ReportInterpretation(
    title: 'VITAMIN D — 17.3 NG/ML',
    flagLabel: 'LOW',
    flag: ReportResultFlag.low,
    whatThisTests:
        'Vitamin D regulates calcium absorption, bone health, and immune function.',
    doctorInterpretation:
        '17.3 ng/mL is deficient. Supplementation and repeat testing in 8 weeks are advised.',
  ),
  ReportInterpretation(
    title: 'HEMOGLOBIN A1C — 5.2%',
    flagLabel: 'HEALTHY',
    flag: ReportResultFlag.healthy,
    whatThisTests: 'HbA1c reflects average blood sugar over the past 3 months.',
    doctorInterpretation:
        '5.2% is within the healthy range. Continue balanced diet and regular activity.',
  ),
];

const _myHealthInterpretationsSep2024 = [
  ReportInterpretation(
    title: 'LDL CHOLESTEROL — 172 MG/DL',
    flagLabel: 'HIGH',
    flag: ReportResultFlag.veryHigh,
    whatThisTests:
        'LDL is "bad" cholesterol that builds up in arteries causing blockages.',
    doctorInterpretation:
        '172 mg/dL is well above optimal. Lifestyle changes and a 3-month lipid recheck were recommended.',
  ),
  ReportInterpretation(
    title: 'VITAMIN D — 11.1 NG/ML',
    flagLabel: 'LOW',
    flag: ReportResultFlag.low,
    whatThisTests:
        'Vitamin D regulates calcium absorption, bone health, and immune function.',
    doctorInterpretation:
        '11.1 ng/mL is severely deficient. High-dose supplementation was started.',
  ),
];

const _momInterpretationsNov2025 = [
  ReportInterpretation(
    title: 'HEMOGLOBIN — 10.5 G/DL',
    flagLabel: 'LOW',
    flag: ReportResultFlag.low,
    whatThisTests:
        'Hemoglobin carries oxygen in red blood cells. Low levels indicate anaemia.',
    doctorInterpretation:
        '10.5 g/dL is below the reference range for women. Iron studies and B12/folate review are recommended.',
  ),
  ReportInterpretation(
    title: 'VITAMIN B12 — 180 PG/ML',
    flagLabel: 'LOW',
    flag: ReportResultFlag.low,
    whatThisTests:
        'B12 is essential for nerve function, red blood cell formation, and DNA synthesis.',
    doctorInterpretation:
        '180 pg/mL is below optimal. Oral or injectable supplementation may be needed based on clinical assessment.',
  ),
];

const _momInterpretationsSep2024 = [
  ReportInterpretation(
    title: 'HEMOGLOBIN — 11.4 G/DL',
    flagLabel: 'LOW',
    flag: ReportResultFlag.low,
    whatThisTests:
        'Hemoglobin carries oxygen in red blood cells.',
    doctorInterpretation:
        '11.4 g/dL was borderline low. Dietary iron intake and follow-up testing were advised.',
  ),
];

const _dadInterpretationsNov2025 = [
  ReportInterpretation(
    title: 'HBA1C — 7.2%',
    flagLabel: 'HIGH',
    flag: ReportResultFlag.veryHigh,
    whatThisTests:
        'HbA1c reflects average blood sugar over 3 months — key marker for diabetes control.',
    doctorInterpretation:
        '7.2% indicates poor glucose control. Lifestyle modification and medical review for diabetes management are needed.',
  ),
  ReportInterpretation(
    title: 'TOTAL CHOLESTEROL — 228 MG/DL',
    flagLabel: 'HIGH',
    flag: ReportResultFlag.veryHigh,
    whatThisTests:
        'Total cholesterol measures all cholesterol types in blood — a cardiovascular risk marker.',
    doctorInterpretation:
        '228 mg/dL exceeds the desirable limit (<200). Diet, exercise, and possible medication should be discussed.',
  ),
  ReportInterpretation(
    title: 'VITAMIN D — 22 NG/ML',
    flagLabel: 'LOW',
    flag: ReportResultFlag.low,
    whatThisTests:
        'Vitamin D supports bone health, immunity, and muscle function.',
    doctorInterpretation:
        '22 ng/mL is insufficient. Weekly supplementation and sunlight exposure are recommended.',
  ),
];

const _dadInterpretationsSep2024 = [
  ReportInterpretation(
    title: 'TOTAL CHOLESTEROL — 210 MG/DL',
    flagLabel: 'HIGH',
    flag: ReportResultFlag.veryHigh,
    whatThisTests:
        'Total cholesterol is a key cardiovascular risk marker.',
    doctorInterpretation:
        '210 mg/dL exceeded the desirable limit. Diet and activity changes were recommended.',
  ),
];

/// Full sample report PDF — replace with your S3 bucket URL when ready.
const guestSampleReportPdfUrl = '';
