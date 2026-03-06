/* ---------------------------------------------
1. CREATE DATABASE
-----------------------------------------------*/

CREATE DATABASE IF NOT EXISTS hospital_patients;
USE hospital_patients;


/* ---------------------------------------------
2. CREATE TABLE
-----------------------------------------------*/
DROP TABLE IF EXISTS hospital_data;

CREATE TABLE hospital_data (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,

  name VARCHAR(150),
  age INT,
  gender VARCHAR(20),
  blood_type VARCHAR(10),
  medical_condition VARCHAR(100),
  admission_date DATE,
  doctor VARCHAR(150),
  hospital VARCHAR(150),
  insurance_provider VARCHAR(100),
  billing_amount DECIMAL(10,2),
  room_number INT,
  admission_type VARCHAR(50),
  discharge_date DATE,
  medication VARCHAR(100),
  test_results VARCHAR(50),

  -- Cleaned columns (keep raw columns untouched)
  name_clean VARCHAR(150),
  doctor_clean VARCHAR(150),

  stay_length INT
);
/* ---------------------------------------------
3. LOAD CSV
-----------------------------------------------*/
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/healthcare_dataset.csv"
INTO TABLE hospital_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(name, age, gender, blood_type, medical_condition, admission_date, doctor, hospital,
 insurance_provider, billing_amount, room_number, admission_type, discharge_date, medication, test_results);
 
 /* ---------------------------------------------
4.  DATA QUALITY CHECK (BEFORE CLEANING)
-----------------------------------------------*/
SELECT
  COUNT(*) AS total_rows,

  -- Identity fields
  SUM(name IS NULL OR TRIM(name) = '') AS blank_names,
  SUM(doctor IS NULL OR TRIM(doctor) = '') AS blank_doctors,
  SUM(hospital IS NULL OR TRIM(hospital) = '') AS blank_hospitals,
  SUM(insurance_provider IS NULL OR TRIM(insurance_provider) = '') AS blank_insurance,

  -- Categorical fields
  SUM(gender IS NULL OR TRIM(gender) = '') AS blank_gender,
  SUM(medical_condition IS NULL OR TRIM(medical_condition) = '') AS blank_condition,
  SUM(admission_type IS NULL OR TRIM(admission_type) = '') AS blank_admission_type,

  -- Numeric fields
  SUM(age IS NULL) AS null_ages,
  SUM(billing_amount IS NULL) AS null_billing,

  -- Date fields
  SUM(admission_date IS NULL) AS null_admission_dates,
  SUM(discharge_date IS NULL) AS null_discharge_dates

FROM hospital_data;
 
 /*----------------------------------------------------------------------------
  5. COPY RAW -> CLEAN COLUMNS (clean these columns and leave the raw untouched)
------------------------------------------------------------------------------*/
UPDATE hospital_data
SET
  name_clean = name,
  doctor_clean = doctor
WHERE patient_id > 0;
 
/* ---------------------------------------------------------------------------
6.BASE CLEANING
---------------------------------------------------------------------------*/
UPDATE hospital_data
SET
  name = TRIM(name),
  gender = TRIM(gender),
  blood_type = TRIM(blood_type),
  medical_condition = TRIM(medical_condition),
  doctor = TRIM(doctor),
  hospital = TRIM(hospital),
  insurance_provider = TRIM(insurance_provider),
  admission_type = TRIM(admission_type),
  medication = TRIM(medication),
  test_results = TRIM(test_results)
WHERE patient_id > 0;

/*
-------------------------------------------------
 7. LOWER + TRIM and normalize multiple spaces 
 ----------------------------------------------- */

-- Patients
UPDATE hospital_data
SET name_clean = LOWER(TRIM(name_clean))
WHERE patient_id > 0 AND name_clean IS NOT NULL;

UPDATE hospital_data
SET name_clean = REPLACE(name_clean, '  ', ' ')
WHERE patient_id > 0 AND name_clean LIKE '%  %';
UPDATE hospital_data
SET name_clean = REPLACE(name_clean, '  ', ' ')
WHERE patient_id > 0 AND name_clean LIKE '%  %';
UPDATE hospital_data
SET name_clean = REPLACE(name_clean, '  ', ' ')
WHERE patient_id > 0 AND name_clean LIKE '%  %';

-- Doctors
UPDATE hospital_data
SET doctor_clean = LOWER(TRIM(doctor_clean))
WHERE patient_id > 0 AND doctor_clean IS NOT NULL;

UPDATE hospital_data
SET doctor_clean = REPLACE(doctor_clean, '  ', ' ')
WHERE patient_id > 0 AND doctor_clean LIKE '%  %';
UPDATE hospital_data
SET doctor_clean = REPLACE(doctor_clean, '  ', ' ')
WHERE patient_id > 0 AND doctor_clean LIKE '%  %';
UPDATE hospital_data
SET doctor_clean = REPLACE(doctor_clean, '  ', ' ')
WHERE patient_id > 0 AND doctor_clean LIKE '%  %';
SELECT * FROM hospital_data LIMIT 50000;
/*---------------------------------------------------------
8. STANDARDIZE TITLES (prefixes) - ensure consistent form
----------------------------------------------------------- */

-- Patients: 
UPDATE hospital_data
SET name_clean = CONCAT('dr. ', SUBSTRING(name_clean, 4))
WHERE patient_id > 0 AND name_clean LIKE 'dr %';
UPDATE hospital_data
SET name_clean = CONCAT('dr. ', SUBSTRING(name_clean, 5))
WHERE patient_id > 0 AND name_clean LIKE 'dr.%';

UPDATE hospital_data
SET name_clean = CONCAT('mr. ', SUBSTRING(name_clean, 4))
WHERE patient_id > 0 AND name_clean LIKE 'mr %';
UPDATE hospital_data
SET name_clean = CONCAT('mr. ', SUBSTRING(name_clean, 5))
WHERE patient_id > 0 AND name_clean LIKE 'mr.%';

UPDATE hospital_data
SET name_clean = CONCAT('mrs. ', SUBSTRING(name_clean, 5))
WHERE patient_id > 0 AND name_clean LIKE 'mrs %';
UPDATE hospital_data
SET name_clean = CONCAT('mrs. ', SUBSTRING(name_clean, 6))
WHERE patient_id > 0 AND name_clean LIKE 'mrs.%';

UPDATE hospital_data
SET name_clean = CONCAT('ms. ', SUBSTRING(name_clean, 4))
WHERE patient_id > 0 AND name_clean LIKE 'ms %';
UPDATE hospital_data
SET name_clean = CONCAT('ms. ', SUBSTRING(name_clean, 5))
WHERE patient_id > 0 AND name_clean LIKE 'ms.%';

UPDATE hospital_data
SET name_clean = CONCAT('miss ', SUBSTRING(name_clean, 6))
WHERE patient_id > 0 AND name_clean LIKE 'miss %';

-- doctors

UPDATE hospital_data
SET doctor_clean = CONCAT('dr. ', SUBSTRING(doctor_clean, 4))
WHERE patient_id > 0 AND doctor_clean LIKE 'dr %';
UPDATE hospital_data
SET doctor_clean = CONCAT('dr. ', SUBSTRING(doctor_clean, 5))
WHERE patient_id > 0 AND doctor_clean LIKE 'dr.%';

UPDATE hospital_data
SET doctor_clean = CONCAT('mr. ', SUBSTRING(doctor_clean, 4))
WHERE patient_id > 0 AND doctor_clean LIKE 'mr %';
UPDATE hospital_data
SET doctor_clean = CONCAT('mr. ', SUBSTRING(doctor_clean, 5))
WHERE patient_id > 0 AND doctor_clean LIKE 'mr.%';

UPDATE hospital_data
SET doctor_clean = CONCAT('mrs. ', SUBSTRING(doctor_clean, 5))
WHERE patient_id > 0 AND doctor_clean LIKE 'mrs %';
UPDATE hospital_data
SET doctor_clean = CONCAT('mrs. ', SUBSTRING(doctor_clean, 6))
WHERE patient_id > 0 AND doctor_clean LIKE 'mrs.%';

UPDATE hospital_data
SET doctor_clean = CONCAT('ms. ', SUBSTRING(doctor_clean, 4))
WHERE patient_id > 0 AND doctor_clean LIKE 'ms %';
UPDATE hospital_data
SET doctor_clean = CONCAT('ms. ', SUBSTRING(doctor_clean, 5))
WHERE patient_id > 0 AND doctor_clean LIKE 'ms.%';

UPDATE hospital_data
SET doctor_clean = CONCAT('miss ', SUBSTRING(doctor_clean, 6))
WHERE patient_id > 0 AND doctor_clean LIKE 'miss %';

/*----------------------------------------------------
9. STANDARDIZE SUFFIX TOKENS (Jr, degrees, III)
First normalize weird forms (".jr", " jr", " jr.")
Then final casing: Jr., MD, PhD, DVM, DDS, III 
----------------------------------------------------*/

-- Patients: normalize jr variants to " jr." (lowercase for now)
UPDATE hospital_data
SET name_clean = REPLACE(name_clean, ' .jr', ' jr.')
WHERE patient_id > 0 AND name_clean LIKE '% .jr%';
UPDATE hospital_data
SET name_clean = REPLACE(name_clean, '.jr', ' jr.')
WHERE patient_id > 0 AND name_clean LIKE '%.jr%';
UPDATE hospital_data
SET name_clean = REPLACE(name_clean, ' jr', ' jr.')
WHERE patient_id > 0 AND name_clean LIKE '% jr';

-- Doctors: normalize jr variants to " jr."
UPDATE hospital_data
SET doctor_clean = REPLACE(doctor_clean, ' .jr', ' jr.')
WHERE patient_id > 0 AND doctor_clean LIKE '% .jr%';
UPDATE hospital_data
SET doctor_clean = REPLACE(doctor_clean, '.jr', ' jr.')
WHERE patient_id > 0 AND doctor_clean LIKE '%.jr%';
UPDATE hospital_data
SET doctor_clean = REPLACE(doctor_clean, ' jr', ' jr.')
WHERE patient_id > 0 AND doctor_clean LIKE '% jr';

/* 10.  --------------------------------------------------------
   TITLE-CASE THE MAIN WORDS
   We handle these cases separately for both columns:
   1) NO TITLE:
      1.1) 2 words: First Last
      1.2) 3 words: First Last SuffixOrDegree
      1.3) 4 words: First Middle Last SuffixOrDegree
   2) WITH TITLE:
      2.1) 3 words: Title First Last
      2.2) 4 words: Title First Middle Last
      2.3) 5 words: Title First Middle Last SuffixOrDegree
   First, We title-case words, then later we force suffix tokens to MD/PhD/etc.
  --------------------------------------------------------------- */
  
  -- PATIENTS

/* 1.1) No title, 2 words (exactly 2 words) */
UPDATE hospital_data
SET name_clean =
  CONCAT(
    UPPER(LEFT(SUBSTRING_INDEX(name_clean,' ',1),1)),
    LOWER(SUBSTRING(SUBSTRING_INDEX(name_clean,' ',1),2)),
    ' ',
    UPPER(LEFT(SUBSTRING_INDEX(name_clean,' ',-1),1)),
    LOWER(SUBSTRING(SUBSTRING_INDEX(name_clean,' ',-1),2))
  )
WHERE patient_id > 0
  AND name_clean IS NOT NULL
  AND name_clean LIKE '% %'
  AND name_clean NOT LIKE '% % %'
  AND name_clean NOT LIKE 'dr.%'
  AND name_clean NOT LIKE 'mr.%'
  AND name_clean NOT LIKE 'mrs.%'
  AND name_clean NOT LIKE 'ms.%'
  AND name_clean NOT LIKE 'miss %';

/* 1.2) No title, 3 words (exactly 3 words) */
UPDATE hospital_data
SET name_clean =
  CONCAT(
    -- word1
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(name_clean,' ',1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(name_clean,' ',1),2))),
    ' ',
    -- word2
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),2))),
    ' ',
    -- word3 (keep as-is for now; will be formatted in suffix step)
    SUBSTRING_INDEX(name_clean,' ',-1)
  )
WHERE patient_id > 0
  AND name_clean LIKE '% % %'
  AND name_clean NOT LIKE '% % % %'
  AND name_clean NOT LIKE 'dr.%'
  AND name_clean NOT LIKE 'mr.%'
  AND name_clean NOT LIKE 'mrs.%'
  AND name_clean NOT LIKE 'ms.%'
  AND name_clean NOT LIKE 'miss %';

/* 1.3) No title, 4 words (exactly 4 words) */
UPDATE hospital_data
SET name_clean =
  CONCAT(
    -- word1
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(name_clean,' ',1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(name_clean,' ',1),2))),
    ' ',
    -- word2
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),2))),
    ' ',
    -- word3
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',3),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',3),' ',-1),2))),
    ' ',
    -- word4 (suffix/degree)
    SUBSTRING_INDEX(name_clean,' ',-1)
  )
WHERE patient_id > 0
  AND name_clean LIKE '% % % %'
  AND name_clean NOT LIKE '% % % % %'
  AND name_clean NOT LIKE 'dr.%'
  AND name_clean NOT LIKE 'mr.%'
  AND name_clean NOT LIKE 'mrs.%'
  AND name_clean NOT LIKE 'ms.%'
  AND name_clean NOT LIKE 'miss %';


/* 2.1) With title, 3 words: title + first + last */
UPDATE hospital_data
SET name_clean =
  CONCAT(
    -- title word (keep as-is for now; will be fixed later: Dr./Mr./Mrs./Ms./Miss)
    SUBSTRING_INDEX(name_clean,' ',1),
    ' ',
    -- first name
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),2))),
    ' ',
    -- last name
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(name_clean,' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(name_clean,' ',-1),2)))
  )
WHERE patient_id > 0
  AND (name_clean LIKE 'dr.% % %'
    OR name_clean LIKE 'mr.% % %'
    OR name_clean LIKE 'mrs.% % %'
    OR name_clean LIKE 'ms.% % %'
    OR name_clean LIKE 'miss % % %')
  AND name_clean NOT LIKE '% % % %';

/* 2.2) With title, 4 words: title + first + middle + last */
UPDATE hospital_data
SET name_clean =
  CONCAT(
    SUBSTRING_INDEX(name_clean,' ',1), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',3),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',3),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(name_clean,' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(name_clean,' ',-1),2)))
  )
WHERE patient_id > 0
  AND (name_clean LIKE 'dr.% % % %'
    OR name_clean LIKE 'mr.% % % %'
    OR name_clean LIKE 'mrs.% % % %'
    OR name_clean LIKE 'ms.% % % %'
    OR name_clean LIKE 'miss % % % %')
  AND name_clean NOT LIKE '% % % % %';

/* 2.3) With title, 5 words: title + first + middle + last + suffix/degree */
UPDATE hospital_data
SET name_clean =
  CONCAT(
    SUBSTRING_INDEX(name_clean,' ',1), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',2),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',3),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',3),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',4),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(name_clean,' ',4),' ',-1),2))), ' ',
    SUBSTRING_INDEX(name_clean,' ',-1)
  )
WHERE patient_id > 0
  AND (name_clean LIKE 'dr.% % % % %'
    OR name_clean LIKE 'mr.% % % % %'
    OR name_clean LIKE 'mrs.% % % % %'
    OR name_clean LIKE 'ms.% % % % %'
    OR name_clean LIKE 'miss % % % % %')
  AND name_clean NOT LIKE '% % % % % %';


-- DOCTORS 

-- 1.1) No title, 2 words
UPDATE hospital_data
SET doctor_clean =
  CONCAT(
    UPPER(LEFT(SUBSTRING_INDEX(doctor_clean,' ',1),1)),
    LOWER(SUBSTRING(SUBSTRING_INDEX(doctor_clean,' ',1),2)),
    ' ',
    UPPER(LEFT(SUBSTRING_INDEX(doctor_clean,' ',-1),1)),
    LOWER(SUBSTRING(SUBSTRING_INDEX(doctor_clean,' ',-1),2))
  )
WHERE patient_id > 0
  AND doctor_clean IS NOT NULL
  AND doctor_clean LIKE '% %'
  AND doctor_clean NOT LIKE '% % %'
  AND doctor_clean NOT LIKE 'dr.%'
  AND doctor_clean NOT LIKE 'mr.%'
  AND doctor_clean NOT LIKE 'mrs.%'
  AND doctor_clean NOT LIKE 'ms.%'
  AND doctor_clean NOT LIKE 'miss %';

-- 1.2) No title, 3 words
UPDATE hospital_data
SET doctor_clean =
  CONCAT(
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(doctor_clean,' ',1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(doctor_clean,' ',1),2))),
    ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),2))),
    ' ',
    SUBSTRING_INDEX(doctor_clean,' ',-1)
  )
WHERE patient_id > 0
  AND doctor_clean LIKE '% % %'
  AND doctor_clean NOT LIKE '% % % %'
  AND doctor_clean NOT LIKE 'dr.%'
  AND doctor_clean NOT LIKE 'mr.%'
  AND doctor_clean NOT LIKE 'mrs.%'
  AND doctor_clean NOT LIKE 'ms.%'
  AND doctor_clean NOT LIKE 'miss %';

-- 1.3) No title, 4 words
UPDATE hospital_data
SET doctor_clean =
  CONCAT(
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(doctor_clean,' ',1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(doctor_clean,' ',1),2))),
    ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),2))),
    ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',3),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',3),' ',-1),2))),
    ' ',
    SUBSTRING_INDEX(doctor_clean,' ',-1)
  )
WHERE patient_id > 0
  AND doctor_clean LIKE '% % % %'
  AND doctor_clean NOT LIKE '% % % % %'
  AND doctor_clean NOT LIKE 'dr.%'
  AND doctor_clean NOT LIKE 'mr.%'
  AND doctor_clean NOT LIKE 'mrs.%'
  AND doctor_clean NOT LIKE 'ms.%'
  AND doctor_clean NOT LIKE 'miss %';

-- 2.1) With title, 3 words
UPDATE hospital_data
SET doctor_clean =
  CONCAT(
    SUBSTRING_INDEX(doctor_clean,' ',1), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(doctor_clean,' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(doctor_clean,' ',-1),2)))
  )
WHERE patient_id > 0
  AND (doctor_clean LIKE 'dr.% % %'
    OR doctor_clean LIKE 'mr.% % %'
    OR doctor_clean LIKE 'mrs.% % %'
    OR doctor_clean LIKE 'ms.% % %'
    OR doctor_clean LIKE 'miss % % %')
  AND doctor_clean NOT LIKE '% % % %';

-- 2.2) With title, 4 words
UPDATE hospital_data
SET doctor_clean =
  CONCAT(
    SUBSTRING_INDEX(doctor_clean,' ',1), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',3),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',3),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(doctor_clean,' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(doctor_clean,' ',-1),2)))
  )
WHERE patient_id > 0
  AND (doctor_clean LIKE 'dr.% % % %'
    OR doctor_clean LIKE 'mr.% % % %'
    OR doctor_clean LIKE 'mrs.% % % %'
    OR doctor_clean LIKE 'ms.% % % %'
    OR doctor_clean LIKE 'miss % % % %')
  AND doctor_clean NOT LIKE '% % % % %';

-- 2.3) With title, 5 words
UPDATE hospital_data
SET doctor_clean =
  CONCAT(
    SUBSTRING_INDEX(doctor_clean,' ',1), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',2),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',3),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',3),' ',-1),2))), ' ',
    CONCAT(UPPER(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',4),' ',-1),1)),
           LOWER(SUBSTRING(SUBSTRING_INDEX(SUBSTRING_INDEX(doctor_clean,' ',4),' ',-1),2))), ' ',
    SUBSTRING_INDEX(doctor_clean,' ',-1)
  )
WHERE patient_id > 0
  AND (doctor_clean LIKE 'dr.% % % % %'
    OR doctor_clean LIKE 'mr.% % % % %'
    OR doctor_clean LIKE 'mrs.% % % % %'
    OR doctor_clean LIKE 'ms.% % % % %'
    OR doctor_clean LIKE 'miss % % % % %')
  AND doctor_clean NOT LIKE '% % % % % %';
  
  /* ---------------------------------------------------------
   11.  FINAL SPACE CLEANUP (some steps can reintroduce doubles)
   ---------------------------------------------------------- */
UPDATE hospital_data SET name_clean = TRIM(name_clean) WHERE patient_id > 0 AND name_clean IS NOT NULL;
UPDATE hospital_data SET doctor_clean = TRIM(doctor_clean) WHERE patient_id > 0 AND doctor_clean IS NOT NULL;

UPDATE hospital_data SET name_clean = REPLACE(name_clean,'  ',' ')
WHERE patient_id > 0 AND name_clean LIKE '%  %';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean,'  ',' ')
WHERE patient_id > 0 AND doctor_clean LIKE '%  %';

  /* --------------------------------------------------------
   10) FINAL STANDARDIZATION (fixes Md/Phd/Dvm/Dds/Iii + Jr.)
 ------------------------------------------------------------ */
-- Titles proper case

UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   'dr.',  'Dr.')  WHERE patient_id > 0 AND name_clean   LIKE 'dr.%';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   'mr.',  'Mr.')  WHERE patient_id > 0 AND name_clean   LIKE 'mr.%';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   'mrs.', 'Mrs.') WHERE patient_id > 0 AND name_clean   LIKE 'mrs.%';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   'ms.',  'Ms.')  WHERE patient_id > 0 AND name_clean   LIKE 'ms.%';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   'miss', 'Miss') WHERE patient_id > 0 AND name_clean   LIKE 'miss %';

UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, 'dr.',  'Dr.')  WHERE patient_id > 0 AND doctor_clean LIKE 'dr.%';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, 'mr.',  'Mr.')  WHERE patient_id > 0 AND doctor_clean LIKE 'mr.%';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, 'mrs.', 'Mrs.') WHERE patient_id > 0 AND doctor_clean LIKE 'mrs.%';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, 'ms.',  'Ms.')  WHERE patient_id > 0 AND doctor_clean LIKE 'ms.%';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, 'miss', 'Miss') WHERE patient_id > 0 AND doctor_clean LIKE 'miss %';

-- Suffix casing (both columns)
-- Jr.
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' jr.', ' Jr.') WHERE patient_id > 0 AND name_clean   LIKE '% jr.%';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' jr.', ' Jr.') WHERE patient_id > 0 AND doctor_clean LIKE '% jr.%';

-- Degrees + Roman numerals (fix both lower and TitleCased)
-- MD
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' md', ' MD') WHERE patient_id > 0 AND name_clean   LIKE '% md';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' md', ' MD') WHERE patient_id > 0 AND doctor_clean LIKE '% md';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' Md', ' MD') WHERE patient_id > 0 AND name_clean   LIKE '% Md';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' Md', ' MD') WHERE patient_id > 0 AND doctor_clean LIKE '% Md';

-- PhD
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' phd', ' PhD') WHERE patient_id > 0 AND name_clean   LIKE '% phd';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' phd', ' PhD') WHERE patient_id > 0 AND doctor_clean LIKE '% phd';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' Phd', ' PhD') WHERE patient_id > 0 AND name_clean   LIKE '% Phd';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' Phd', ' PhD') WHERE patient_id > 0 AND doctor_clean LIKE '% Phd';

-- DVM
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' dvm', ' DVM') WHERE patient_id > 0 AND name_clean   LIKE '% dvm';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' dvm', ' DVM') WHERE patient_id > 0 AND doctor_clean LIKE '% dvm';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' Dvm', ' DVM') WHERE patient_id > 0 AND name_clean   LIKE '% Dvm';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' Dvm', ' DVM') WHERE patient_id > 0 AND doctor_clean LIKE '% Dvm';

-- DDS
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' dds', ' DDS') WHERE patient_id > 0 AND name_clean   LIKE '% dds';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' dds', ' DDS') WHERE patient_id > 0 AND doctor_clean LIKE '% dds';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' Dds', ' DDS') WHERE patient_id > 0 AND name_clean   LIKE '% Dds';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' Dds', ' DDS') WHERE patient_id > 0 AND doctor_clean LIKE '% Dds';

-- III
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' iii', ' III') WHERE patient_id > 0 AND name_clean   LIKE '% iii';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' iii', ' III') WHERE patient_id > 0 AND doctor_clean LIKE '% iii';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' Iii', ' III') WHERE patient_id > 0 AND name_clean   LIKE '% Iii';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' Iii', ' III') WHERE patient_id > 0 AND doctor_clean LIKE '% Iii';

-- II
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' ii', ' II') WHERE patient_id > 0 AND name_clean   LIKE '% ii';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' ii', ' II') WHERE patient_id > 0 AND doctor_clean LIKE '% ii';
UPDATE hospital_data SET name_clean   = REPLACE(name_clean,   ' Ii', ' II') WHERE patient_id > 0 AND name_clean   LIKE '% Ii';
UPDATE hospital_data SET doctor_clean = REPLACE(doctor_clean, ' Ii', ' II') WHERE patient_id > 0 AND doctor_clean LIKE '% Ii';


/* --------------------------------------------------------
   12. REMOVE INVALID DATE ORDER (safe mode friendly)
  --------------------------------------------------------- */
DELETE FROM hospital_data
WHERE patient_id > 0
  AND discharge_date IS NOT NULL
  AND admission_date IS NOT NULL
  AND discharge_date < admission_date;


/*-----------------------------------------------------------
   13. DERIVED METRIC: stay_length
   ---------------------------------------------------------- */
UPDATE hospital_data
SET stay_length = DATEDIFF(discharge_date, admission_date)
WHERE patient_id > 0
  AND discharge_date IS NOT NULL
  AND admission_date IS NOT NULL
  AND discharge_date >= admission_date;



/* -----------------------------------------------------------
    14. POST-CLEANING CHECKS
  ------------------------------------------------------------ */
SELECT
  COUNT(*) AS total_rows,
  SUM(name_clean IS NULL OR TRIM(name_clean)='') AS blank_patient_names,
  SUM(doctor_clean IS NULL OR TRIM(doctor_clean)='') AS blank_doctor_names,
  SUM(stay_length IS NULL) AS null_stay_length
FROM hospital_data;

SELECT patient_id, name, name_clean, doctor, doctor_clean
FROM hospital_data
WHERE patient_id > 0;
AND (name <> name_clean OR doctor <> doctor_clean)
LIMIT 50000;


/* -----------------------------------------------------------
    15. CLEAN VIEW FOR EXCEL
  ------------------------------------------------------------ */
  
CREATE VIEW hospital_clean_view AS
SELECT
  patient_id,
  name_clean AS name,
  doctor_clean AS doctor,
  age,
  gender,
  medical_condition,
  insurance_provider,
  billing_amount,
  admission_date,
  discharge_date,
  stay_length
FROM hospital_data;

SELECT * FROM hospital_clean_view;

/*-------------------------------------------------
 16. ANALYSIS QUERIES FOR EXCEL EXPORT 
 -------------------------------------------------*/
-- A) Top medical conditions
SELECT medical_condition, COUNT(*) AS total_cases
FROM hospital_data
GROUP BY medical_condition
ORDER BY total_cases DESC;

-- B) Average billing by condition
SELECT medical_condition, ROUND(AVG(billing_amount),2) AS avg_bill
FROM hospital_data
GROUP BY medical_condition
ORDER BY avg_bill DESC;

-- C) Revenue by insurance provider
SELECT insurance_provider, ROUND(SUM(billing_amount),2) AS total_revenue
FROM hospital_data
GROUP BY insurance_provider
ORDER BY total_revenue DESC;

-- D) Monthly admissions trend
SELECT DATE_FORMAT(admission_date,'%Y-%m') AS month, COUNT(*) AS admissions
FROM hospital_data
GROUP BY month
ORDER BY month;

-- E) Avg stay by admission type
SELECT admission_type, ROUND(AVG(stay_length),2) AS avg_stay_days
FROM hospital_data
GROUP BY admission_type
ORDER BY avg_stay_days DESC;

-- F) Gender breakdown
SELECT gender, COUNT(*) AS patients
FROM hospital_data
GROUP BY gender
ORDER BY patients DESC;

