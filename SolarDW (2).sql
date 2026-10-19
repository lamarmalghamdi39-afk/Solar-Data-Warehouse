CREATE DATABASE solardw;

USE solardw;

-- ============================================
-- DIM_DATE
-- جدول البعد الخاص بالتاريخ
-- ============================================

CREATE TABLE DIM_DATE (
    date_key VARCHAR(12) PRIMARY KEY,     -- مفتاح التاريخ
    full_date DATE,                       -- التاريخ الكامل
    day INT,
    month INT,
    year INT,
    quarter INT,
    hour INT,
    weekday VARCHAR(20)
);

SHOW TABLES;
DESCRIBE dim_date;

-- ============================================
-- DIM_PLANT
-- جدول البعد الخاص بالمحطات
-- ============================================

CREATE TABLE DIM_PLANT (
    plant_key INT PRIMARY KEY,      -- مفتاح المحطة
    PLANT_ID INT,                   -- رقم المحطة من البيانات
    plant_name VARCHAR(50)          -- اسم المحطة
);

SHOW TABLES;

-- ============================================
-- DIM_SOURCE
-- جدول البعد الخاص بالمصادر (الإنفرترات)
-- ============================================


CREATE TABLE DIM_SOURCE (
    source_key INT PRIMARY KEY,      -- مفتاح تسلسلي للمصدر
    SOURCE_ID VARCHAR(50)            -- معرف الإنفرتر الحقيقي
);

SHOW TABLES;

-- ============================================
-- FACT_POWER_GENERATION
-- جدول الحقائق الرئيسي
-- ============================================

CREATE TABLE FACT_POWER_GENERATION (

    fact_id INT AUTO_INCREMENT PRIMARY KEY,

    -- المفاتيح الأجنبية
    date_key VARCHAR(12),
    source_key INT,
    plant_key INT,

    -- مقاييس التوليد
    DC_POWER DOUBLE,
    AC_POWER DOUBLE,
    DAILY_YIELD DOUBLE,
    TOTAL_YIELD DOUBLE,

    -- بيانات حساس الطقس
    AMBIENT_TEMPERATURE DOUBLE,
    MODULE_TEMPERATURE DOUBLE,
    IRRADIATION DOUBLE,

    -- بيانات الطقس الخارجية 2019
    Temperature DOUBLE,
    DHI DOUBLE,
    DNI DOUBLE,
    GHI DOUBLE,
    Relative_Humidity DOUBLE,
    Pressure DOUBLE,
    Wind_Speed DOUBLE,

    -- العلاقات
    FOREIGN KEY (date_key)
        REFERENCES DIM_DATE(date_key),

    FOREIGN KEY (source_key)
        REFERENCES DIM_SOURCE(source_key),

    FOREIGN KEY (plant_key)
        REFERENCES DIM_PLANT(plant_key)
);
SHOW TABLES;

DESCRIBE fact_power_generation;

SELECT *
FROM fact_power_generation
LIMIT 20;

SELECT COUNT(*) AS total_rows
FROM fact_power_generation;

SELECT DISTINCT source_key
FROM fact_power_generation;

SELECT plant_key,
       AVG(DAILY_YIELD) AS avg_daily_yield
FROM fact_power_generation
GROUP BY plant_key;

SELECT date_key,
       plant_key,
       DAILY_YIELD
FROM fact_power_generation
ORDER BY DAILY_YIELD DESC
LIMIT 10;
-- ============================================================
-- 1. عدد الصفوف في DIM_DATE
-- ============================================================
SELECT 
    'DIM_DATE' AS table_name,
    COUNT(*) AS row_count
FROM DIM_DATE;

-- ============================================================
-- 2. عدد الصفوف في DIM_PLANT
-- ============================================================
SELECT 
    'DIM_PLANT' AS table_name,
    COUNT(*) AS row_count
FROM DIM_PLANT;

-- ============================================================
-- 3. عدد الصفوف في DIM_SOURCE
-- ============================================================
SELECT 
    'DIM_SOURCE' AS table_name,
    COUNT(*) AS row_count
FROM DIM_SOURCE;

-- ============================================================
-- 4. عدد الصفوف في FACT_POWER_GENERATION
-- ============================================================
SELECT 
    'FACT_POWER_GENERATION' AS table_name,
    COUNT(*) AS row_count
FROM FACT_POWER_GENERATION;


SELECT COUNT(*) AS dim_source_rows
FROM dim_source;


-- ============================================================
-- ============================================================


-- Question 1:
-- What are the peak hours for solar power generation?
-- الهدف:
-- معرفة الساعات التي تحقق أعلى إنتاج للطاقة
-- ============================================================

SELECT 
    d.hour,
    AVG(f.AC_POWER) AS avg_ac_power
FROM fact_power_generation f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.hour
ORDER BY avg_ac_power DESC;







-- ============================================================
-- Question 2:
-- Which inverter (SOURCE_ID) generates the highest daily yield?
-- الهدف:
-- معرفة أفضل الإنفرترات أداءً
-- ============================================================

SELECT
    s.SOURCE_ID,
    AVG(f.DAILY_YIELD) AS avg_daily_yield
FROM fact_power_generation f
JOIN dim_source s
ON f.source_key = s.source_key
GROUP BY s.SOURCE_ID
ORDER BY avg_daily_yield DESC;



-- ============================================================
-- Question 3:
-- How does solar irradiation impact AC power generation?
-- الهدف:
-- قياس العلاقة بين الإشعاع الشمسي والطاقة المنتجة
-- ============================================================

SELECT
    ROUND(f.IRRADIATION,1) AS irradiation_level,
    AVG(f.AC_POWER) AS avg_power
FROM fact_power_generation f
GROUP BY ROUND(f.IRRADIATION,1)
ORDER BY irradiation_level;



-- ============================================================
-- Question 4:
-- Which days achieve the highest average power generation?
-- الهدف:
-- معرفة الأيام الأعلى إنتاجية خلال الأسبوع
-- ============================================================

SELECT
    d.weekday,
    AVG(f.AC_POWER) AS avg_ac_power
FROM fact_power_generation f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.weekday
ORDER BY avg_ac_power DESC;


