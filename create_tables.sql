-- SQL Script to Create Database Tables for University Admin App
-- Run this on your Render PostgreSQL database

-- Create sequences
CREATE SEQUENCE IF NOT EXISTS account_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS advert_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS agespan_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS area_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS bulletin_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS bulletinimage_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS feature_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS feetype_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS institution_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS institutionimage_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS school_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS schoolimage_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS schooltype_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS terminal_id_seq START WITH 1 INCREMENT BY 1;

-- Account table
CREATE TABLE IF NOT EXISTS account (
    id INTEGER DEFAULT nextval('account_id_seq') PRIMARY KEY,
    username VARCHAR(100),
    password VARCHAR(510),
    name VARCHAR(40),
    telephone VARCHAR(100),
    role INTEGER DEFAULT 0,
    flag_telephone INTEGER,
    checkcode VARCHAR(50),
    source VARCHAR(20),
    dtcreate TIMESTAMP
);

-- Advert table
CREATE TABLE IF NOT EXISTS advert (
    id INTEGER DEFAULT nextval('advert_id_seq') PRIMARY KEY,
    title VARCHAR(200),
    website VARCHAR(200),
    image_file VARCHAR(200)
);

-- Agespan table
CREATE TABLE IF NOT EXISTS agespan (
    id INTEGER DEFAULT nextval('agespan_id_seq') PRIMARY KEY,
    name VARCHAR(100),
    fromage INTEGER,
    toage INTEGER
);

-- Area table
CREATE TABLE IF NOT EXISTS area (
    id INTEGER DEFAULT nextval('area_id_seq') PRIMARY KEY,
    name VARCHAR(100)
);

-- Bulletin table
CREATE TABLE IF NOT EXISTS bulletin (
    id INTEGER DEFAULT nextval('bulletin_id_seq') PRIMARY KEY,
    dt TIMESTAMP WITH TIME ZONE,
    title VARCHAR(200),
    content VARCHAR(10000),
    valid INTEGER DEFAULT 1,
    source VARCHAR(70),
    author VARCHAR(70)
);

-- Bulletinimage table
CREATE TABLE IF NOT EXISTS bulletinimage (
    id INTEGER DEFAULT nextval('bulletinimage_id_seq') PRIMARY KEY,
    bulletin_id INTEGER REFERENCES bulletin(id),
    file VARCHAR(500)
);

-- Feature table
CREATE TABLE IF NOT EXISTS feature (
    id INTEGER DEFAULT nextval('feature_id_seq') PRIMARY KEY,
    name VARCHAR(100)
);

-- Feetype table
CREATE TABLE IF NOT EXISTS feetype (
    id INTEGER DEFAULT nextval('feetype_id_seq') PRIMARY KEY,
    name VARCHAR(400)
);

-- Schooltype table
CREATE TABLE IF NOT EXISTS schooltype (
    id INTEGER DEFAULT nextval('schooltype_id_seq') PRIMARY KEY,
    name VARCHAR(100)
);

-- Institution table
CREATE TABLE IF NOT EXISTS institution (
    id INTEGER DEFAULT nextval('institution_id_seq') PRIMARY KEY,
    name VARCHAR(200),
    area_id INTEGER REFERENCES area(id),
    agespan_id INTEGER REFERENCES agespan(id),
    address VARCHAR(200),
    location VARCHAR(200),
    website VARCHAR(200),
    telephone VARCHAR(200),
    feedesc VARCHAR(200),
    feetype_id INTEGER REFERENCES feetype(id),
    longitude REAL,
    latitude REAL,
    featuredesc VARCHAR(400),
    feature_id INTEGER REFERENCES feature(id),
    timeopen TIMESTAMP,
    timeclose TIMESTAMP
);

-- Institution_feature table
CREATE TABLE IF NOT EXISTS institution_feature (
    institution_id INTEGER REFERENCES institution(id) ON UPDATE CASCADE ON DELETE CASCADE,
    feature_id INTEGER REFERENCES feature(id) ON UPDATE CASCADE,
    PRIMARY KEY (institution_id, feature_id)
);

-- Institutionimage table
CREATE TABLE IF NOT EXISTS institutionimage (
    id INTEGER DEFAULT nextval('institutionimage_id_seq') PRIMARY KEY,
    institution_id INTEGER REFERENCES institution(id) ON UPDATE CASCADE ON DELETE CASCADE,
    file VARCHAR(1000)
);

-- School table
CREATE TABLE IF NOT EXISTS school (
    id INTEGER DEFAULT nextval('school_id_seq') PRIMARY KEY,
    name VARCHAR(200),
    area_id INTEGER REFERENCES area(id),
    teachdesc VARCHAR(4000),
    address VARCHAR(200),
    schooltype_id INTEGER REFERENCES schooltype(id),
    website VARCHAR(200),
    leisure VARCHAR(2000),
    threashold VARCHAR(2000),
    partner VARCHAR(200),
    artsource VARCHAR(2000),
    feedesc VARCHAR(200),
    distinguish VARCHAR(2000),
    longitude REAL,
    latitude REAL,
    feature_id INTEGER REFERENCES feature(id)
);

-- School_feature table
CREATE TABLE IF NOT EXISTS school_feature (
    school_id INTEGER REFERENCES school(id) ON UPDATE CASCADE ON DELETE CASCADE,
    feature_id INTEGER REFERENCES feature(id) ON UPDATE CASCADE,
    PRIMARY KEY (school_id, feature_id)
);

-- Schoolimage table
CREATE TABLE IF NOT EXISTS schoolimage (
    id INTEGER DEFAULT nextval('schoolimage_id_seq') PRIMARY KEY,
    school_id INTEGER REFERENCES school(id) ON UPDATE CASCADE ON DELETE CASCADE,
    file VARCHAR(1000)
);

-- Terminal table
CREATE TABLE IF NOT EXISTS terminal (
    id INTEGER DEFAULT nextval('terminal_id_seq') PRIMARY KEY,
    account_id INTEGER REFERENCES account(id) ON UPDATE CASCADE ON DELETE CASCADE,
    type INTEGER,
    code VARCHAR(510)
);

-- Test table
CREATE TABLE IF NOT EXISTS test (
    "user" VARCHAR(50) PRIMARY KEY,
    tt TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS institution_agespan_id_idx ON institution(agespan_id);
CREATE INDEX IF NOT EXISTS institution_area_id_idx ON institution(area_id);
CREATE INDEX IF NOT EXISTS institution_feature_id_idx ON institution(feature_id);
CREATE INDEX IF NOT EXISTS institution_feetype_id_idx ON institution(feetype_id);
CREATE INDEX IF NOT EXISTS institution_feature_feature_id_idx ON institution_feature(feature_id);
CREATE INDEX IF NOT EXISTS institution_feature_institution_id_idx ON institution_feature(institution_id);
CREATE INDEX IF NOT EXISTS institutionimage_institution_id_idx ON institutionimage(institution_id);
CREATE INDEX IF NOT EXISTS school_area_id_idx ON school(area_id);
CREATE INDEX IF NOT EXISTS school_feature_id_idx ON school(feature_id);
CREATE INDEX IF NOT EXISTS school_schooltype_id_idx ON school(schooltype_id);
CREATE INDEX IF NOT EXISTS school_feature_feature_id_idx ON school_feature(feature_id);
CREATE INDEX IF NOT EXISTS school_feature_school_id_idx ON school_feature(school_id);
CREATE INDEX IF NOT EXISTS schoolimage_school_id_idx ON schoolimage(school_id);
CREATE INDEX IF NOT EXISTS terminal_account_id_idx ON terminal(account_id);

-- Insert initial data for lookup tables

-- Insert agespan data
INSERT INTO agespan (id, name, fromage, toage) VALUES
(1, '小学生', 6, 13),
(2, '幼儿', 3, 10),
(3, '成人', 18, 120),
(4, '小学生及中学生', 6, 18)
ON CONFLICT (id) DO NOTHING;

-- Insert area data
INSERT INTO area (id, name) VALUES
(1, '浦东新区'),
(2, '徐汇区'),
(3, '黄浦区'),
(4, '卢湾区'),
(5, '静安区'),
(6, '长宁区'),
(7, '闵行区'),
(8, '杨浦区'),
(9, '普陀区'),
(10, '虹口区'),
(11, '宝山区'),
(12, '闸北区'),
(13, '松江区'),
(14, '嘉定区'),
(15, '青浦区'),
(16, '奉贤区'),
(17, '金山区'),
(18, '崇明县')
ON CONFLICT (id) DO NOTHING;

-- Insert feature data
INSERT INTO feature (id, name) VALUES
(0, ''),
(1, '艺术（声乐、乐器、绘画、舞蹈）'),
(2, '语言（英语、小语种）'),
(3, '体育'),
(4, '课外辅导（语文、奥数）'),
(5, '思维逻辑'),
(6, '国学（书法、国画、围棋、蒙学）')
ON CONFLICT (id) DO NOTHING;

-- Insert feetype data
INSERT INTO feetype (id, name) VALUES
(1, '按时间收费'),
(2, '按等级收费')
ON CONFLICT (id) DO NOTHING;

-- Insert schooltype data
INSERT INTO schooltype (id, name) VALUES
(1, '幼儿园'),
(2, '小学'),
(3, '初中'),
(4, '高中'),
(5, '中等职业学校'),
(6, '大专'),
(7, '大学')
ON CONFLICT (id) DO NOTHING;

-- Update sequences to correct values
SELECT setval('agespan_id_seq', (SELECT MAX(id) FROM agespan));
SELECT setval('area_id_seq', (SELECT MAX(id) FROM area));
SELECT setval('feature_id_seq', (SELECT MAX(id) FROM feature));
SELECT setval('feetype_id_seq', (SELECT MAX(id) FROM feetype));
SELECT setval('schooltype_id_seq', (SELECT MAX(id) FROM schooltype));
