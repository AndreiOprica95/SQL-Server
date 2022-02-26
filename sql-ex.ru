Exercise 1

--//Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
Result set: model, speed, hd//--
    
SELECT p.model, p.speed, p.hd FROM pc p
    WHERE price < 500

  
Exercise 2
  
--//List all printer makers. Result set: maker.//--
   
SELECT DISTINCT product.maker from product
    WHERE product.type like '%printer'

  
Exercise 3
  
 --//Find the model number, RAM and screen size of the laptops with prices over $1000.//--
    
 SELECT l.model,l.ram,l.screen FROM laptop l
       WHERE price > 1000
    

Exercise 4

 --//Find all records from the Printer table containing data about color printers.//--
 
SELECT * FROM printer
    WHERE color = 'y'

    
Exercise 5
    
--//Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.//--
        
 SELECT model,speed,hd FROM pc
    WHERE cd IN('12x','24x')     
       AND price < 600

   
Exercise 6
    
 --//For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.//--
        
SELECT DISTINCT p.maker, l.speed FROM product p

JOIN laptop l ON p.model = l.model
WHERE l.hd >= 10

    
Exercise 7
    
 --//Get the models and prices for all commercially available products (of any type) produced by maker B //--
         
SELECT x.model, x.price FROM 
     (SELECT p.maker, l.model, l.price FROM product p
         JOIN laptop l ON p.model = l.model

UNION
         SELECT p.maker, pc.model, pc.price FROM product p
            JOIN pc ON p.model = pc.model

UNION
         SELECT p.maker, pr.model, pr.price FROM product p
            JOIN printer pr ON p.model = pr.model) x
            WHERE maker = 'B'

    
    
Exercise 8
     
--//Find the makers producing PCs but not laptops.//--
  
SELECT maker FROM product
    WHERE type = 'pc'

EXCEPT

SELECT maker FROM product
    WHERE type = 'laptop'

    
    
Exercise 9
     
--//Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.//--
         
SELECT DISTINCT x.maker FROM
    (SELECT p.maker, pc.speed FROM product p
        JOIN pc ON p.model = pc.model) x

WHERE x.speed >= 450

    
    
Exercise 10
     
--//Find the printer models having the highest price. Result set: model, price.//--
         
SELECT pr.model, price from printer pr
    WHERE price = (SELECT MAX(price) from printer)

    
    
Exercise 11
     
--//Find out the average speed of PCs.//--
     
 SELECT AVG(pc.speed) FROM pc

    
    
Exercise 12
     
 --//Find out the average speed of the laptops priced over $1000.//--
         
SELECT AVG(l.speed) FROM laptop l
    WHERE price > 1000

    
    
Exercise 13
     
--//Find out the average speed of the PCs produced by maker A.//--
         
SELECT AVG(pc.speed) FROM PC
    JOIN product ON product.model = pc.model
    WHERE maker = 'a'

    
    
Exercise 14
     
 --//For the ships in the Ships table that have at least 10 guns, get the class, name, and country.//--
         
SELECT x.class, x.name, c.country FROM 
  (SELECT s.class, s.name FROM ships S) x
    JOIN classes c ON x.name = c.class OR x.class = c.class
    WHERE numGuns >= 10

Exercise 15
     
 --//Get hard drive capacities that are identical for two or more PCs.//--
         
SELECT x.hd FROM 
    (SELECT hd, COUNT(hd) 'count' FROM  pc
    GROUP BY hd) x  
WHERE x.count >= 2
 
Exercise 16
     
--//Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).//--
         
SELECT DISTINCT a.model,b.model,a.speed, a.ram FROM pc a
    JOIN  pc b ON a.speed = b.speed
        AND  a.ram = b.ram
        AND  a.model > b.model

Exercise 17
     
--//Get the laptop models that have a speed smaller than the speed of any PC.//--
    
SELECT DISTINCT prod.type, l.model, l.speed FROM product prod, laptop l
    WHERE prod.type = 'laptop'
    AND l.speed < ALL (SELECT pc.speed FROM pc)

Exercise 18
     
--//Find the makers of the cheapest color printers.//--
         
SELECT DISTINCT prod.maker, pr.price FROM product prod
    JOIN printer pr ON prod.model = pr.model
        WHERE pr.price = (SELECT MIN(price) FROM printer WHERE color = 'y')
        AND color = 'y'

Exercise 19
     
--//For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.//--
         
SELECT prod.maker, AVG(l.screen) as 'Average_Screen' FROM product prod
    JOIN laptop l ON prod.model = l.model
        GROUP BY maker

Exercise 20
     
--//Find the makers producing at least three distinct models of PCs.//--
         
SELECT x.maker, COUNT(x.model) as 'Count_model'
    FROM
        (SELECT prod.maker, prod.model FROM product prod
            WHERE type = 'pc')  x
                GROUP by maker
                HAVING COUNT(x.model) >=3

Exercise 21
     
 --//Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.//--
         
SELECT x.maker, MAX(x.price) FROM
    (SELECT prod.maker,pc.price FROM product prod
        JOIN pc ON prod.model = pc.model) x
            GROUP BY maker

Exercise 22
     
--//For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds //--
 
SELECT pc.speed, AVG(pc.price) as 'Average_price' FROM pc
    WHERE speed > 600
    GROUP BY speed

     
Exercise 23
     
 --//Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.//--
         
SELECT prod.maker FROM product prod
    JOIN pc on prod.model = pc.model
    WHERE pc.speed >= 750

INTERSECT

SELECT prod.maker FROM product prod
    JOIN laptop l on prod.model = l.model
    WHERE l.speed >= 750

Exercise 24
     
 --//List the models of any type having the highest price of all products present in the database.//--
         
WITH cte AS

(
SELECT l.model, l.price FROM laptop l
    WHERE price = (SELECT MAX(price) FROM laptop)

UNION

SELECT pc.model, pc.price FROM pc
    WHERE price = (SELECT MAX(price) FROM pc)

UNION

SELECT pr.model, pr.price FROM printer pr
    WHERE price = (SELECT MAX(price) FROM printer)
)

SELECT cte.model FROM cte
    WHERE cte.price = (SELECT MAX(price) FROM cte)


Exercise 25
Exercise 26
     
--//Find out the average price of PCs and laptops produced by maker A.//--
         
SELECT AVG(x.price) as 'AVG_price' FROM
    (SELECT maker,type,price FROM product p
        JOIN pc ON p.model = pc.model
        WHERE maker = 'A'
UNION ALL

SELECT maker,type,price FROM product p
    JOIN laptop ON p.model = laptop.model
    WHERE maker = 'A') x

Exercise 27
     
--//Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.//--
         
SELECT p.maker, AVG(pc.hd) as 'AVG_hd' FROM product p
    JOIN pc ON p.model = pc.model
    WHERE p.maker IN (SELECT maker from product WHERE type = 'printer')
    GROUP BY maker

Exercise 28
--//Using Product table, find out the number of makers who produce only one model.//--
         
SELECT COUNT(x.maker) FROM
(SELECT maker, COUNT(model) as 'qty' FROM product
    GROUP BY maker) x
        WHERE qty = 1

Exercise 29
     
--//Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense).//--
        
SELECT x.point, x.date,SUM(x.inc) as 'INC', SUM(x.out) as 'out' FROM
    (SELECT i.point, i.date, i.inc, NULL AS 'out' FROM income_o i
    UNION
    SELECT o.point, o.date, NULL AS 'inc', o.out FROM outcome_o o) X
        GROUP BY x.point, x.date

Exercise 30
    
    
WITH raw AS
(SELECT i.point,i.date,i.inc, NULL out
    FROM Income i
UNION all

SELECT o.point,o.date, NULL  inc,o.out
    FROM Outcome o)

SELECT point,date, sum(out) Outcome, sum(inc) Income FROM raw
    GROUP by point,date

Exercise 31
 
 --//For ship classes with a gun caliber of 16 in. or more, display the class and the country.//--
        
SELECT a.class, a.country FROM Classes a
    WHERE a.bore >= 16

Exercise 32
 --//One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw).
Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.//--
        
WITH cte AS(
    
(SELECT country, bore 'b', name FROM classes,ships
    WHERE classes.class = ships.class
UNION
SELECT country, bore 'b', ship 'name' from classes, outcomes
    WHERE classes.class = outcomes.ship)
)
SELECT country, CAST(AVG(B*B*B/2) AS decimal(10,2)) FROM cte
    GROUP by country

Exercise 33
    
--//Get the ships sunk in the North Atlantic battle.//--
        
SELECT ship FROm Outcomes
    WHERE result = 'sunk'
    AND battle like '%Atlantic'

Exercise 34
 
--//In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons.
Get the ships violating this treaty (only consider ships for which the year of launch is known).
List the names of the ships.//--
        
WITH cte AS
(SELECT x.name, c.displacement FROM
    (SELECT s.name, s.launched, c.class  FROM ships s, classes c
        WHERE s.class = c.class
        AND type = 'bb'
        AND launched >= 1922
        AND launched IS NOT NULL) x
    JOIN Classes c ON x.class = c.class)
    
SELECT name FROM CTE
    WHERE displacement > 35000
    
Exercise 35
    
 --//Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.//-
         
SELECT model, type FROM Product
    WHERE model NOT LIKE '%[^A-Z]%' 
    OR model NOT LIKE '%[^0-9]%'

Exercise 36

--//List the names of lead ships in the database (including the Outcomes table).//--
      
SELECT s.name FROM ships s
    JOIN Classes c ON s.name = c.class

UNION

SELECT o.ship FROM outcomes o
    JOIN classes c ON o.ship = c.class
     

Exercise 37
     
--//Find classes for which only one ship exists in the database (including the Outcomes table).//--
        
WITH cte AS(
    SELECT x.class, COUNT(x.name) AS 'Count' FROM 
        (SELECT s.name, c.class FROM ships s, classes c
         WHERE s.class = c.class
    UNION
         SELECT o.ship as 'name', c.class FROM outcomes o, classes C
         WHERE o.ship = c.class) x
              GROUP BY x.class)

SELECT class FROM cte
where COUNT = 1

Exercise 38
    
--//Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).//--
        
    SELECT country FROM classes
        WHERE type = 'bb'
INTERSECT
    SELECT country FROM classes
        WHERE type = 'bc'

Exercise 39
    
--//Find the ships that `survived for future battles`; that is, after being damaged in a battle, they participated in another one, which occurred later.//--
        
SELECT DISTINCT y.ship FROM
    (SELECT ship,date FROM outcomes o, battles b  WHERE o.battle = b.name) Y
        JOIN 
(SELECT o.ship, o.battle, o.result, b.date as 'dmgdate' FROM outcomes o
       JOIN battles b ON o.battle = b.name
        WHERE result = 'damaged') X
    ON x.ship = y.ship and y.date > x.dmgdate

Exercise 40
  
  --//Get the makers who produce only one product type and more than one model.//--
  
SELECT DISTINCT x.maker,p.type FROM
    (SELECT maker,COUNT(distinct type) as 'numType',COUNT(model) as'numModel' FROM product
        GROUP BY maker) x
JOIN product p ON x.maker = p.maker
    WHERE x.numType =1 AND x.numModel > 1

Exercise 41
    
--//For each maker who has models at least in one of the tables PC, Laptop, or Printer, determine the maximum price for his products.
Output: maker; if there are NULL values among the prices for the products of a given maker, display NULL for this maker, otherwise, the maximum price.//--
        
WITH qq AS 

(SELECT maker,price FROM product
    JOIN pc ON product.model = pc.model
UNION
SELECT maker,price FROM product
    JOIN laptop ON product.model = laptop.model
UNION
SELECT maker,price FROM product
    JOIN printer ON product.model = printer.model)

SELECT maker,
    CASE WHEN
        SUM(CASE WHEN price is NULL then 1 else 0 END) = 1 THEN NULL
            ELSE max(price)
            END m_price
                FROM qq
                    GROUP BY maker

Exercise 42
            
--//Get the battles that occurred in years when no ships were launched into water.//--
  
SELECT ship,battle FROM outcomes
    WHERE result = 'sunk'


Exercise 43
  
 --//Find the names of ships sunk at battles, along with the names of the corresponding battles.//--
  
WITH qq AS
    (SELECT DATEPART(year,date) as 'tdate' FROM battles
        EXCEPT
     SELECT launched AS 'tdate' FROM ships)

SELECT yy.name FROM
    (SELECT x.name, qq.tdate FROM
        (SELECT b.name, DATEPART(year,date) as 'adate' FROM battles b) x
      JOIN qq ON qq.tdate = x.adate) yy
            
            
Exercise 44
   
 --//Find all ship names beginning with the letter R//--
                
SELECT DISTINCT  qq.name FROM
    (SELECT name FROM ships
    UNION 
    SELECT ship FROM outcomes) qq
WHERE qq.name like 'r%'
        
Exercise 45
   
--//Find all ship names consisting of three or more words (e.g., King George V).
Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces.//--
                
SELECT ship FROM outcomes
    WHERE ship like '% % %'
UNION
SELECT name FROM ships
    WHERE name like '% % %'

Exercise 46
            
--//For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.//--
                
 SELECT x.ship, c.displacement, c.numGuns FROM
    (SELECT  o.ship , COALESCE(s.class, o.ship) class
                       FROM outcomes o
                       LEFT JOIN ships s ON s.name = o.ship
     WHERE o.battle = 'Guadalcanal') x
        LEFT JOIN classes c ON x.class = c.class

Exercise 47
        
--//Find the countries that have lost all their ships in battles.//--
            
 WITH shipCount AS (
    SELECT x.country, COUNT(*) as 'boats' FROM
        (SELECT o.ship as 'name', c.country FROM outcomes o
            JOIN classes c ON o.ship = c.class
            UNION
         SELECT s.name as 'name', c.country FROm ships s
            JOIN classes c ON s.class = c.class) x
        GROUP BY country),

sunkCount AS
    (SELECT x.country, COUNT(*) as 'scount' 
        FROM
            (SELECT s.name name, c.country FROM classes c
                JOIN ships s ON c.class = s.class
             UNION
             SELECT o.ship name, c.country FROM classes c
                JOIN outcomes o ON c.class = o.ship) x
                JOIN outcomes o ON o.ship = x.name 
                    WHERE result = 'sunk'
                        GROUP by country)

SELECT a.country FROM  shipcount a
    JOIN sunkcount b on a.country = b.country
        WHERE a.boats = b.scount

Exercise 48
  
--//Find the ship classes having at least one ship sunk in battles.//--
            
SELECT class FROM classes
    WHERE class IN
        (SELECT  q.class FROM
            (SELECT s.name ship, c.class class FROM ships s
                JOIN classes c ON c.class = s.class
                    UNION 
             SELECT o.ship ship,c.class class FROM outcomes o
                JOIN classes c ON  c.class = o.ship) q
                JOIN outcomes o ON o.ship = q.ship
                    WHERE o.result = 'sunk')
                
                
Exercise 49
                
--//Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).//--
                    
WITH 
                
allShips AS 
   (SELECT o.ship FROM outcomes o
    UNION
    SELECT s.name FROM ships s),

allClasses AS
    (SELECT x.ship,s.class FROM allShips x
        JOIN ships s ON x.ship = s.name
     UNION
    SELECT x.ship,c.class FROM allShips x
        JOIN classes c ON c.class = x.ship),

isolatedResults AS
     (SELECT q.ship,c.bore FROM allclasses q
        JOIN classes c on q.class = c.class
            WHERE bore = 16)

Select ship FROM isolatedResults

                
Exercise 50

 --//Find the battles in which Kongo-class ships from the Ships table were engaged.//--
         
SELECT DISTINCT o.battle FROM
    (SELECT  o.ship, s.class FROM outcomes o
        JOIN ships s ON o.ship = s.name OR o.ship = s.class) x
            JOIN outcomes o ON x.ship = o.ship
            WHERE class = 'Kongo'

Exercise 51
                
--//ind the names of the ships with the largest number of guns among all ships having the same displacement (including ships in the Outcomes table).//--
                    
WITH 
shipsInfo AS(
        SELECT o.ship,s.class FROM Outcomes o
            JOIN ships s ON o.ship = s.name
        UNION 
        SELECT s.name,s.class FROM ships s
        UNION
        SELECT o.ship, c.class FROM outcomes o
            JOIN classes c ON o.ship = c.class),

rawData1 AS(
         SELECT x.ship, c.displacement FROM shipsInfo x
            JOIN classes C ON c.class = x.class),
                
rawData2 AS(
         SELECT x.ship, c.displacement,numGuns FROM shipsInfo x
            JOIN classes C ON c.class = x.class),

rawData3 AS(
          SELECT y.displacement, MAX(numGuns) as'MaxNumGuns' FROM rawdata2 y
          GROUP BY y.displacement)

SELECT qq.ship FROM rawdata2 qq
    JOIN rawdata3 yy ON yy.displacement = qq.displacement
        WHERE qq.Numguns = yy.MaxNumGuns

Exercise 52
                
--//Determine the names of all ships in the Ships table that can be a Japanese battleship having at least nine main guns with a caliber of less than 19 inches and a displacement of not more than 65 000 tons.//--
                    
SELECT distinct S.name
    FROM   Ships as S INNER JOIN Classes as C
        ON     S.class = C.class
        WHERE  (C.country = 'Japan' or C.country is null)
            AND (C.type = 'bb' or C.type is null)
            AND (numGuns >= 9  or numGuns is null)
            AND (bore < 19  or bore is null)
            AND (displacement <= 65000  or displacement is null)

Exercise 53
                
--//With a precision of two decimal places, determine the average number of guns for the battleship classes//--
        
SELECT CAST(AVG(numGuns * 1.0) AS DECIMAL(10,2))  FROM classes
    WHERE type = 'bb'

Exercise 54

--//With a precision of two decimal places, determine the average number of guns for all battleships (including the ones in the Outcomes table).//--
        
WITH 
raw AS(
    SELECT x.name as 'battleship',c.numGuns FROM
        (SELECT s.name,s.class FROM ships s
            UNION
         SELECT o.ship, c.class FROM outcomes o
                JOIN classes c ON  o.ship = c.class) x
                JOIN classes c ON c.class = x.class
                    WHERE type = 'bb')
    
SELECT CAST(AVG(numGuns *1.0) AS DECIMAL(10,2)) FROM raw

Exercise 55
   
--//For each class, determine the year the first ship of this class was launched.
If the lead ship’s year of launch is not known, get the minimum year of launch for the ships of this class.//--
        
SELECT s.class, MIN(s.launched) launched FROM ships s
        GROUP BY class
UNION
SELECT c.class, MIN(s.launched) launched FROM classes c
    LEFT JOIN ships s ON c.class = s.class
        GROUP by c.class

Exercise 56
            
--//For each class, find out the number of ships of this class that were sunk in battles.//--
 
WITH 
sunksPerclass AS(
            SELECT c.class,
                   CASE WHEN o.result = 'sunk' THEN 1 ELSE 0 END Sunks
                        FROM classes c LEFT JOIN outcomes o ON c.class = o.ship
                            WHERE class NOT IN (SELECT name FROM ships)
        UNION ALL
             SELECT s.class,
                    CASE WHEN o.result = 'sunk' THEN 1 ELSE 0 END Sunks
                         FROM ships s LEFT JOIN Outcomes o ON s.name = o.ship)
    
SELECT x.class,SUM(x.sunks) Sunks FROM sunksPerclass x
GROUp by class

Exercise 57
    
--//For classes having irreparable combat losses and at least three ships in the database, display the name of the class and the number of ships sunk.//--
        
 WITH 
 permaDmg AS(
        SELECT c.class, s.name ship, o.result FROM classes c
            JOIN ships s ON c.class = s.class
            JOIN Outcomes o ON s.name = o.ship
                WHERE result = 'sunk'
        UNION
        SELECT c.class, o.ship, o.result FROM classes c
            JOIN outcomes o on c.class = o.ship
                WHERE result = 'sunk'),

allClassShips AS(
              SELECT s.class, x.ship FROM
                  (SELECT o.ship FROM outcomes o
                    UNION
                    SELECT s.name FROm ships s) x
    
              JOIN ships s ON s.name = x.ship
                    UNION
                SELECT c.class, y.ship FROM
                    (SELECT o.ship FROM outcomes o
                        UNION
                     SELECT s.name FROm ships s) y
                JOIN classes c ON c.class = y.ship),

validCount AS(
         SELECT x.class, COUNT(x.ship) howmany FROM allClassShips x
              GROUP BY class
                    HAVING COUNT(x.ship) >= 3)


SELECT x.class, COUNT(y.result) FROM validCount x
    JOIN permaDmg y ON x.class = y.class
        GROUP BY x.class
    
Exercise 59
    
--//Calculate the cash balance of each buy-back center for the database with money transactions being recorded not more than once a day.//--
   
WITH 
incomeTotal AS(
            SELECT point,sum(inc) itotal FROM Income_o
                GROUP BY point),
outcomeTotal AS(
            SELECT point,sum(out) ototal FROM Outcome_o
                 GROUP by point)

SELECT i.point,
        CASE WHEN itotal is NULL THEN 0 ELSE itotal END
                -
        CASE WHEN ototal is NULL THEN 0 ELSE ototal END

            FROM incomeTotal i LEFT JOIN outcomeTotal o ON i.point = o.point
    
Exercise 60
    
--//For the database with money transactions being recorded not more than once a day, calculate the cash balance of each buy-back center at the beginning of 4/15/2001.
Note: exclude centers not having any records before the specified date//--
        
WITH 
inc AS(
    SELECT point, SUM(inc) inc FROM income_O
        WHERE date  < '20010415'
        GROUP BY point),
out AS(
    SELECT point,SUM(out) out FROM outcome_o
    WHERE DATE < '20010415'
    GROUP BY point)

SELECT i.point,
        CASE WHEN inc IS NULL THEN 0 ELSE inc END
                    -
         CASE WHEN out IS NULL THEN 0 ELSE out END
                  AS  Remain
        FROM inc i
            LEFT JOIN out o ON i.point = o.point
