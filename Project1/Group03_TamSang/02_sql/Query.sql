-- ดูรายการเมนูทั้งหมดที่พร้อมขาย
SELECT Name, Price 
FROM MENU 
WHERE Status = 'A';

-- ดูรายการวัตถุดิบทั้งหมดที่พร้อมขาย
SELECT Name
FROM INGREDIENT
WHERE Status = 'A';

-- เช็คสถานะโต๊ะทั้งหมดว่าตอนนี้โต๊ะไหนว่างอยู่บ้าง
SELECT Table_ID, Status 
FROM TABLES 
WHERE Status = 'A';

-- แสดงว่ามีทอปปิ้งอยู่บ้าง
SELECT Name, Price   
FROM MENU
WHERE Category_Menu_ID = 2;

-- แสดงพนักงานทั้งหมดในร้าน
SELECT First_Name, Last_Name, MT.Name, Phone
FROM MEMBER M
JOIN MEMBER_TYPE MT ON M.Member_Type_ID = MT.Member_Type_ID
WHERE M.MEMBER_TYPE_ID > 1;

-- ดึงข้อมูลออเดอร์พร้อมชื่อพนักงานที่รับเงิน
SELECT P.Order_ID, P.Amount, P.Payment_Date, M.First_Name 
FROM PAYMENT P
JOIN MEMBER M ON P.Member_ID = M.Member_ID;

-- ตรวจสอบรายการอาหารในออเดอร์ ว่ามีอะไรบ้าง
SELECT OI.Order_Item_ID, M.Name AS Menu_Name, OI.Quantity, T.Name AS Topping_Name, OIT.Quantity AS Topping_Quatity
FROM ORDER_ITEM OI
JOIN MENU M ON OI.Menu_ID = M.Menu_ID
LEFT JOIN ORDER_ITEM_TOPPING OIT ON OI.Order_Item_ID = OIT.Order_Item_ID
LEFT JOIN MENU T ON OIT.Topping_ID = T.Menu_ID
WHERE OI.Order_ID = 5;

