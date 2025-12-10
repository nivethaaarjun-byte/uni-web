-- SQL script to replace Chinese data with English data
-- Run this script to update your PostgreSQL database with English content

-- Delete existing data (in correct order to respect foreign keys)
DELETE FROM schoolfeature;
DELETE FROM institutionfeature;
DELETE FROM schoolimage;
DELETE FROM institutionimage;
DELETE FROM bulletinimage;
DELETE FROM school;
DELETE FROM institution;
DELETE FROM bulletin;
DELETE FROM area;
DELETE FROM feature;
DELETE FROM schooltype;
DELETE FROM agespan;
DELETE FROM feetype;

-- Insert English data for areas (districts)
INSERT INTO area (id, name) VALUES 
(1, 'Downtown'),
(2, 'Uptown'),
(3, 'Midtown'),
(4, 'East District'),
(5, 'West District'),
(6, 'North District'),
(7, 'South District'),
(8, 'Central District'),
(9, 'Riverside'),
(10, 'Hillside'),
(11, 'Lakefront'),
(12, 'Harbor Area'),
(13, 'Garden District'),
(14, 'Industrial Zone'),
(15, 'University District'),
(16, 'Historic Quarter'),
(17, 'Business District'),
(18, 'Suburban Area');

-- Insert English data for features
INSERT INTO feature (id, name) VALUES
(1, 'Science Lab'),
(2, 'Sports Facilities'),
(3, 'Arts Program'),
(4, 'Music Department'),
(5, 'Computer Lab'),
(6, 'Library'),
(7, 'Swimming Pool');

-- Insert English data for school types
INSERT INTO schooltype (id, name) VALUES
(1, 'Public School'),
(2, 'Private School'),
(3, 'Charter School'),
(4, 'Magnet School'),
(5, 'Montessori'),
(6, 'International School'),
(7, 'Special Education');

-- Insert English data for age spans
INSERT INTO agespan (id, name, fromage, toage) VALUES
(1, 'Preschool', 3, 5),
(2, 'Elementary', 6, 11),
(3, 'Middle School', 12, 14),
(4, 'High School', 15, 18);

-- Insert English data for fee types
INSERT INTO feetype (id, name) VALUES
(1, 'Free'),
(2, 'Low Cost'),
(3, 'Standard Fee'),
(4, 'Premium');

-- Sample bulletin in English
INSERT INTO bulletin (id, dt, title, content, valid, source, author) VALUES
(1, NOW(), 'Welcome to Our University Admin System', 'This is a sample bulletin. You can add schools, institutions, and manage student information through this admin panel.', 1, 'Admin', 'System Administrator');

-- Note: You can add sample schools and institutions through the web interface at:
-- https://uni-web-l8ba.onrender.com/bd/view_school
-- https://uni-web-l8ba.onrender.com/bd/view_institution
`