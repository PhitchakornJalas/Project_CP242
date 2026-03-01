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
    Name VARCHAR(100) NOT NULL, -- หมวดหมู่อาหาร
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE MENU (
    Menu_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL, -- ชื่อเมนู
    Detail TEXT, -- รายละเอียดเมนู
    Price DECIMAL(10, 2) NOT NULL, -- ราคา
    Recommend BOOLEAN NOT NULL DEFAULT FALSE, -- true = เป็นเมนูแนะนำ / false = ไม่เป็นเมนูแนะนำ
    Spicy_Level BOOLEAN NOT NULL DEFAULT FALSE, -- true = ลูกค้าสามารถระบุความเผ็ดได้ / false = ไม่ต้องการลูกค้าสามารถระบุความเผ็ด
    Status VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (Status IN ('A', 'U')), -- สถานะของเมนู (A = พร้อมขาย | U = ไม่พร้อมขาย)
    Pic_Path VARCHAR(255),
    Category_Menu_ID INT REFERENCES CATEGORY_MENU(Category_Menu_ID),
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE CATEGORY_INGREDIENT (
    Category_Ingredient_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL, -- หมวดหมู่วัตถุดิบ
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE INGREDIENT (
    Ingredient_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL, -- วัตถุดิบ
    Status VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (Status IN ('A', 'U')), -- สถานะของวัตถุดิบ (A = พร้อมขาย | U = ไม่พร้อมขาย)
    Category_Ingredient_ID INT REFERENCES CATEGORY_INGREDIENT(Category_Ingredient_ID),
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE MENU_INGREDIENT ( -- เมนูประกอบไปด้วยวัตถุดิบอะไร
    Menu_ID INT REFERENCES MENU(Menu_ID),
    Ingredient_ID INT REFERENCES INGREDIENT(Ingredient_ID),
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL,
    PRIMARY KEY (Menu_ID, Ingredient_ID)
);

CREATE TABLE MENU_TOPPING ( -- เมนูสามารถเพิ่ม topping อะไรได้บ้าง
    Menu_ID INT REFERENCES MENU(Menu_ID),
    Topping_ID INT REFERENCES MENU(Menu_ID),
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL,
    PRIMARY KEY (Menu_ID, Topping_ID)
);

-- =========================================
-- 2. หมวดการขายและการให้บริการ
-- =========================================

CREATE TABLE TABLES (
    Table_ID VARCHAR(3) PRIMARY KEY,
    Number_Of_Seats INT NOT NULL,
    Status VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (Status IN ('A', 'U', 'P')), -- สถานะของโต๊ะ (A = ว่าง | U = ไม่ว่าง | P = ชำระเงิน)
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE ORDERS (
    Order_ID SERIAL PRIMARY KEY,
    Table_ID VARCHAR(3) REFERENCES TABLES(Table_ID),
    Order_Date TIMESTAMP NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (Status IN ('A', 'U')), -- สถานะของออเดอร์ (A = กำลังใช้งาน | U = ชำระเงินแล้ว)
    Last_Update TIMESTAMP,
    Last_Update_By VARCHAR(50)
);

CREATE TABLE ORDER_ITEM (
    Order_Item_ID SERIAL PRIMARY KEY,
    Order_ID INT REFERENCES ORDERS(Order_ID),
    Menu_ID INT REFERENCES MENU(Menu_ID),
    Spicy_Level INT NOT NULL DEFAULT 0 CHECK (Spicy_Level IN (0, 1, 2, 3, 4)), -- ระดับความเผ็ดที่ลูกค้าต้องการ (0 = ไม่ให้เลือกความเผ็ด | 1 = ไม่เผ็ด | 2 = เผ็ดน้อย | 3 = เผ็ดปกติ | 4 = เผ็ดมาก)
    Requirement TEXT,
    Quantity INT NOT NULL DEFAULT 1,
    Price DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (Status IN ('A', 'F', 'C')), -- สถานะเมนูในออเดอร์ (A = กำลังทำ | F = เสร็จแล้ว | C = ยกเลิก)
    Order_Time TIMESTAMP NOT NULL,
    Finish_Time TIMESTAMP,
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE ORDER_ITEM_TOPPING (
    Order_Item_Topping_ID SERIAL PRIMARY KEY,
    Order_Item_ID INT REFERENCES ORDER_ITEM(Order_Item_ID),
    Topping_ID INT REFERENCES MENU(Menu_ID),
    Quantity INT NOT NULL DEFAULT 1,
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

-- =========================================
-- 3. หมวดสมาชิก(พนักงาน) และการเงิน
-- =========================================

CREATE TABLE MEMBER_TYPE (
    Member_Type_ID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE MEMBER (
    Member_ID SERIAL PRIMARY KEY,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(1) NOT NULL, -- เพศ(M = ชาย | W = หญิง)
    Username VARCHAR(50) UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Member_Type_ID INT REFERENCES MEMBER_TYPE(Member_Type_ID),
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE PAYMENT (
    Payment_ID SERIAL PRIMARY KEY,
    Order_ID INT REFERENCES ORDERS(Order_ID),
    Amount DECIMAL(10, 2)  NOT NULL,
    Method VARCHAR(1) NOT NULL, -- วิธีการชำระเงิน(C = เงินสด | Q = สแกนจ่าย)
    Member_ID INT REFERENCES MEMBER(Member_ID),
    Payment_Date TIMESTAMP NOT NULL,
    Bill_Path VARCHAR(255) NOT NULL,
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE COST (
    Cost_ID SERIAL PRIMARY KEY,
    Cost_Date DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description TEXT,
    Member_ID INT REFERENCES MEMBER(Member_ID),
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

-- =========================================
-- 4. หมวดระบบและบันทึกการทำงาน
-- =========================================

CREATE TABLE TAMSANG_CONFIG (
    ID SERIAL PRIMARY KEY,
    Title VARCHAR(100) NOT NULL DEFAULT 'TamSang',
    Merchant_id VARCHAR(50) NOT NULL, -- เลขบัญชีธนาคาร
    Last_Update TIMESTAMP NOT NULL,
    Last_Update_By VARCHAR(50) NOT NULL
);

CREATE TABLE LOG (
    Log_ID SERIAL PRIMARY KEY,
    TimeStamp TIMESTAMP NOT NULL,
    "user" VARCHAR(50) NOT NULL,
    User_Type VARCHAR(50) NOT NULL,
    Action VARCHAR(100) NOT NULL,
    Detail TEXT NOT NULL,
    Order_ID INT REFERENCES ORDERS(Order_ID)
);