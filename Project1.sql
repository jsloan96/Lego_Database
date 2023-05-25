-- Create a new schema
CREATE SCHEMA LegoDatabase;

-- Use schema
USE LegoDatabase;


/** ****************************** Create tables ******************************
******************************************************************************/

/** This table includes information on lego themes. Each theme is given a unique ID number,
 a name, and (if it's part of a bigger theme) which theme it's part of. **/
DROP TABLE IF EXISTS `themes`;
CREATE TABLE themes (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  parent_id INT
);
 
/** This table contains information on LEGO colors, including a unique ID for each color,
its name, and approximate RGB value, and whether it's transparent **/
DROP TABLE IF EXISTS `colors`;
CREATE TABLE colors (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  rgb VARCHAR(255),
  is_trans CHAR(1)
);

/** This table includes information on the part category (what type of part it is) 
and a unique ID for that part category. **/
DROP TABLE IF EXISTS `part_categories`;
CREATE TABLE part_categories (
  id INT PRIMARY KEY,
  name VARCHAR(255)
);

/** This file contains information on LEGO sets, including a unique ID number, the name of the set, 
the year it was released, its theme and how many parts it includes. **/
DROP TABLE IF EXISTS `sets`;
CREATE TABLE sets (
  set_num VARCHAR(25) PRIMARY KEY,
  name VARCHAR(255),
  year INT,
  theme_id INT,
  num_parts INT,
  CONSTRAINT fk_theme_id FOREIGN KEY (theme_id) REFERENCES themes(id)
);

/** This table contains information on inventories, including a unique ID, it's version and the set number. **/
DROP TABLE IF EXISTS `inventories`;
CREATE TABLE inventories (
  id INT PRIMARY KEY,
  version INT,
  set_num VARCHAR(255),
  CONSTRAINT fk_set_num FOREIGN KEY (set_num) REFERENCES sets(set_num)
);

/** This table includes information on lego parts, including a unique ID number, the name of the part, 
and what part category it's from. **/
DROP TABLE IF EXISTS `parts`;
CREATE TABLE parts (
  part_num VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255),
  part_cat_id INT,
  CONSTRAINT fk_part_cat_id FOREIGN KEY (part_cat_id) REFERENCES part_categories(id)
);

/** This table contains information on what inventory is included in which sets, including the inventory ID,
 the set number and the quantity of that inventory that are included. **/
DROP TABLE IF EXISTS `inventory_sets`;
CREATE TABLE inventory_sets (
    inventory_id INT,
    set_num VARCHAR(20),
    quantity INT,
    PRIMARY KEY (inventory_id, set_num),
    FOREIGN KEY (inventory_id) REFERENCES inventories(id),
    FOREIGN KEY (set_num) REFERENCES sets(set_num)
);

/** This table contains information part inventories, including a unique ID number, the part number, 
the color of the part, how many are included and whether it's a spare. **/
DROP TABLE IF EXISTS `inventory_parts`;
CREATE TABLE inventory_parts (
  inventory_id INT,
  part_num VARCHAR(255),
  color_id INT,
  quantity INT,
  is_spare CHAR,
  CONSTRAINT fk_inventory_id FOREIGN KEY (inventory_id) REFERENCES inventories(id),
  CONSTRAINT fk_part_num FOREIGN KEY (part_num) REFERENCES parts(part_num),
  CONSTRAINT fk_color_id FOREIGN KEY (color_id) REFERENCES colors(id)
);


-- Add indexes for optimization
CREATE INDEX idx_theme_id ON sets (theme_id);
CREATE INDEX idx_color_id ON inventory_parts (color_id);
CREATE INDEX idx_part_num ON inventory_parts (part_num);


-- View the database and its tables
SHOW TABLES;
DESCRIBE colors;
DESCRIBE inventories;
DESCRIBE inventory_parts;
DESCRIBE part_categories;
DESCRIBE parts;
DESCRIBE sets;
DESCRIBE themes;


/**
-- Import data onto the tables (DOES NOT WORK) 
-- Import data using Import Wizard instead

SET FOREIGN_KEY_CHECKS=0;
LOAD DATA LOCAL INFILE '/Users/jeremysloan/Documents/School/2023_Spring/ITCS_3160(DatabaseDesign)/Project/Lego_Database' INTO TABLE colors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET FOREIGN_KEY_CHECKS=1;

**/


/********************************* VIEW TABLES *******************************
******************************************************************************/
SELECT * FROM themes; -- FIX THEMES IMPORT ERROR (614 OUT OF 614 ROWS IMPORTED)
SELECT * FROM colors; -- COLORS IMPORTED 135 OUT OF 135 ROWSthemes
SELECT * FROM part_categories; -- PART_CATEGORIES IMPORTED 57 OUT OF 57 ROWS

SELECT * FROM sets; -- FIX SETS IMPORT ERROR (199 OUT OF 11673 ROWS IMPORTED)
SELECT * FROM inventories; -- FIX INVENTORIES IMPORT ERROR (38 OUT OF 11681 ROWS IMPORTED)
SELECT * FROM parts; -- FIX PARTS IMPORT ERROR (6362 OUT OF 25998 ROWS IMPORTED)
SELECT * FROM inventory_sets; -- FIX INVENTORY_SETS IMPORT ERROR (3 OUT OF 2847 ROWS IMPORTED)
SELECT * FROM inventory_parts; -- FIX INVENTORY_PARTS IMPORT ERROR (186 OUT OF 580251 ROWS IMPORTED)

SELECT COUNT(*) FROM inventory_parts; -- Count Rows
