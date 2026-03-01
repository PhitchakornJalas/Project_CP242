-- =========================================
-- 0) Clean up
-- =========================================
DROP TABLE IF EXISTS LOG;
DROP TABLE IF EXISTS TAMSANG_CONFIG;
DROP TABLE IF EXISTS COST;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS MEMBER;
DROP TABLE IF EXISTS MEMBER_TYPE;
DROP TABLE IF EXISTS ORDER_ITEM_TOPPING;
DROP TABLE IF EXISTS ORDER_ITEM;
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS TABLES;
DROP TABLE IF EXISTS MENU_TOPPING;
DROP TABLE IF EXISTS MENU_INGREDIENT;
DROP TABLE IF EXISTS INGREDIENT;
DROP TABLE IF EXISTS CATEGORY_INGREDIENT;
DROP TABLE IF EXISTS MENU;
DROP TABLE IF EXISTS CATEGORY_MENU;

-- =========================================
-- 1. หมวดเมนูและวัตถุดิบ
-- =========================================

CREATE TABLE CATEGORY_MENU (
    Category_Menu_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE MENU (
    Menu_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Detail TEXT,
    Price DECIMAL(10, 2),
    Recommend BOOLEAN,
    Spicy_Level BOOLEAN,
    Status VARCHAR(20),
    Pic_Path VARCHAR(255),
    Category_Menu_ID INT REFERENCES CATEGORY_MENU(Category_Menu_ID),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE CATEGORY_INGREDIENT (
    Category_Ingredient_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE INGREDIENT (
    Ingredient_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Status VARCHAR(1),
    Category_Ingredient_ID INT REFERENCES CATEGORY_INGREDIENT(Category_Ingredient_ID),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE MENU_INGREDIENT (
    Menu_ID INT REFERENCES MENU(Menu_ID),
    Ingredient_ID INT REFERENCES INGREDIENT(Ingredient_ID),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50),
    PRIMARY KEY (Menu_ID, Ingredient_ID)
);

CREATE TABLE MENU_TOPPING (
    Menu_ID INT REFERENCES MENU(Menu_ID),
    Topping_ID INT REFERENCES MENU(Menu_ID),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50),
    PRIMARY KEY (Menu_ID, Topping_ID)
);

-- =========================================
-- 2. หมวดการขายและการให้บริการ
-- =========================================

CREATE TABLE TABLES (
    Table_ID SERIAL PRIMARY KEY,
    Number_Of_Seats INT,
    Status VARCHAR(1),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE ORDERS (
    Order_ID SERIAL PRIMARY KEY,
    Table_ID INT REFERENCES TABLES(Table_ID),
    Order_Date TIMESTAMP,
    Amount DECIMAL(10, 2),
    Status VARCHAR(1),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE ORDER_ITEM (
    Order_Item_ID SERIAL PRIMARY KEY,
    Order_ID INT REFERENCES ORDERS(Order_ID),
    Menu_ID INT REFERENCES MENU(Menu_ID),
    Spicy_Level INT,
    Requirement TEXT,
    Quantity INT,
    Price DECIMAL(10, 2),
    Status VARCHAR(1),
    Order_Time TIMESTAMP,
    Finish_Time TIMESTAMP,
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE ORDER_ITEM_TOPPING (
    Order_Item_Topping_ID SERIAL PRIMARY KEY,
    Order_Item_ID INT REFERENCES ORDER_ITEM(Order_Item_ID),
    Topping_ID INT REFERENCES MENU(Menu_ID),
    Quantity INT,
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

-- =========================================
-- 3. หมวดสมาชิก(พนักงาน) และการเงิน
-- =========================================

CREATE TABLE MEMBER_TYPE (
    Member_Type_ID SERIAL PRIMARY KEY,
    Name VARCHAR(50),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE MEMBER (
    Member_ID SERIAL PRIMARY KEY,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Gender VARCHAR(1),
    Username VARCHAR(50) UNIQUE,
    Password VARCHAR(255),
    Phone VARCHAR(20),
    Member_Type_ID INT REFERENCES MEMBER_TYPE(Member_Type_ID),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE PAYMENT (
    Payment_ID SERIAL PRIMARY KEY,
    Order_ID INT REFERENCES ORDERS(Order_ID),
    Amount DECIMAL(10, 2),
    Method VARCHAR(1),
    Member_ID INT REFERENCES MEMBER(Member_ID),
    Payment_Date TIMESTAMP,
    Bill_Path VARCHAR(255),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE COST (
    Cost_ID SERIAL PRIMARY KEY,
    Cost_Date DATE,
    Amount DECIMAL(10, 2),
    Description TEXT,
    Member_ID INT REFERENCES MEMBER(Member_ID),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

-- =========================================
-- 4. หมวดระบบและบันทึกการทำงาน
-- =========================================

CREATE TABLE TAMSANG_CONFIG (
    ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Merchant_id VARCHAR(50),
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE LOG (
    Log_ID SERIAL PRIMARY KEY,
    TimeStamp TIMESTAMP,
    "user" VARCHAR(50),
    User_Type VARCHAR(50),
    Action VARCHAR(100),
    Detail TEXT,
    Order_ID INT REFERENCES ORDERS(Order_ID)
);