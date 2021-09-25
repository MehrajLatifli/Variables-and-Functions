-- Functions 
use Library



-- Write a function that returns a list of books with the minimum number of pages issued by a particular publisher


CREATE OR ALTER FUNCTION function_1_1(@publishername as nvarchar(50))
RETURNS nvarchar (50)
AS
BEGIN
  declare @bookname as nvarchar(50)
  Select  
  @bookname =Library.dbo.Books.Name
  from
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
  where 
  Library.dbo.Press.Name=@publishername
  AND
  Library.dbo.Books.Pages=
   (
    Select  
    Min(Pages)
    from 
    Library.dbo.Books 
    Inner Join Library.dbo.Press
    ON
    Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
    where 
    Library.dbo.Press.Name=@publishername
   )
  RETURN @bookname
END




declare @result_1_1 nvarchar(50)
exec @result_1 = function_1 N'Piter'
print @result




CREATE OR ALTER FUNCTION function_1_2(@publishername as nvarchar(50))
RETURNS TABLE
AS
RETURN
 (
  Select  
  Library.dbo.Books.Pages,
  Library.dbo.Books.[Name] as Book,
  Library.dbo.Press.[Name] as Pulblisher
  from
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
  where 
  Library.dbo.Press.Name=@publishername
  AND
  Library.dbo.Books.Pages=
   (
    Select  
    Min(Pages)
    from 
    Library.dbo.Books 
    Inner Join Library.dbo.Press
    ON
    Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
    where 
    Library.dbo.Press.Name=@publishername
   )
 )




select * from function_1_2(N'Piter')




-- Write a function that returns the names of publishers who have published books with an average number of pages greater than N. The average number of pages is passed through the parameter.


CREATE OR ALTER FUNCTION function_2_1(@AVGpagegreatenthanN as int)
RETURNS nvarchar (50)
AS
BEGIN
  declare @publishername as nvarchar(50)
  Select  
  @publishername = Library.dbo.Press.[Name]
  from 
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
  Group by 
  Library.dbo.Press.Id,
  Library.dbo.Press.[Name]
  Having
  AVG(Pages)>@AVGpagegreatenthanN
  RETURN @publishername
End




declare @result_2 nvarchar(50)
exec @result_2 = function_2_1 100
print @result_2




CREATE OR ALTER FUNCTION function_2_2(@AVGpagegreatenthanN as int)
RETURNS TABLE
AS
RETURN
 (
  Select  
  AVG(Pages) AS [AVG(Pages)>N],
  Library.dbo.Press.[Name] as Pulblisher
  from 
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
  Group by 
  Library.dbo.Press.Id,
  Library.dbo.Press.[Name]
  Having
  AVG(Pages)>@AVGpagegreatenthanN
 )




select * from function_2_2(100)




-- Write a function that returns the total sum of the pages of all the books in the library issued by the specified publisher.


CREATE OR ALTER FUNCTION function_3_1(@publisher as nvarchar(50))
RETURNS bigint
AS
BEGIN 
  declare @sumpages as bigint=0
  Select  
  @sumpages = SUM(Pages)
  from
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
  where 
  Library.dbo.Press.Name=@publisher
  RETURN @sumpages
END




declare @result_3 bigint
exec @result_3=function_3_1 N'Binom'
print @result_3




CREATE OR ALTER FUNCTION function_3_2(@publisher as nvarchar(50))
RETURNS TABLE
AS
RETURN
 (
  Select  
  SUM(Pages) as [Sum of Pages]
  from
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id 
  where 
  Library.dbo.Press.[Name]=@publisher
 )




 select * from function_3_2(N'Binom')




-- Write a function that returns a list of names and surnames of all students who took books between the two specified dates


CREATE OR ALTER FUNCTION function_4(@datein as nvarchar(50), @dateout as nvarchar(50))
RETURNS TABLE
AS
RETURN
 (
  Select
  Library.dbo.S_Cards.DateIn,
  Library.dbo.S_Cards.DateOut,
  Library.dbo.Students.FirstName,
  Library.dbo.Students.LastName
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
  Group by 
  Library.dbo.S_Cards.DateIn,
  Library.dbo.S_Cards.DateOut,
  Library.dbo.Students.FirstName,
  Library.dbo.Students.LastName
  Having
  Library.dbo.S_Cards.DateIn >=@datein
  AND
  Library.dbo.S_Cards.DateIn<=@dateout 
 )




select * from function_4(N'2000-01-01 00:00:00.000', N'2010-01-01 00:00:00.000')




-- Write a function that returns a list of students who are currently working with the specified book of a certain author.


CREATE OR ALTER FUNCTION function_5(@AuthorFirstName as nvarchar(50), @AuthorLastName as nvarchar(50), @BookName as nvarchar(50))
RETURNS TABLE
AS
RETURN
 (
  Select
  Library.dbo.Students.FirstName,
  Library.dbo.Students.LastName
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
  Inner Join Library.dbo.Authors
  ON
  Library.dbo.Authors.Id=Library.dbo.Books.Id_Author
  where
  Library.dbo.Authors.FirstName=@AuthorFirstName
  AND
  Library.dbo.Authors.LastName=@AuthorLastName
  AND
  Library.dbo.Books.[Name]=@BookName
 )




 select * from function_5(N'Markus', N'Herhager', N'Mathcad 2000')




 -- Write a function that returns information about publishers whose total number of pages of books issued by them is greater than N 


CREATE OR ALTER FUNCTION function_6(@SumbiggerthanN as bigint)
RETURNS TABLE
AS
RETURN
 (
  Select  
  SUM(Pages) as [SUM(Pages)],
  Library.dbo.Press.[Name] as Publisher
  from
  Library.dbo.Books 
  Inner Join Library.dbo.Press
  ON
  Library.dbo.Books.Id_Press=Library.dbo.Press.Id
  GROUP BY
  Library.dbo.Press.Id,
  Library.dbo.Press.[Name]
  Having
  SUM(Pages)>@SumbiggerthanN
 )




 select * from function_6(100)




 -- Write a function that returns information about the most popular author among students and about the number of books of this author taken in the library


CREATE OR ALTER FUNCTION function_7_1()
RETURNS nvarchar (50)
AS
BEGIN
  declare @AuthorFulltName as nvarchar(50)
  Select  
  TOP(1)
  @AuthorFulltName= Library.dbo.Authors.FirstName + ' ' + Library.dbo.Authors.LastName
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
  Inner Join Library.dbo.Authors
  ON
  Library.dbo.Authors.Id=Library.dbo.Books.Id_Author
  RETURN @AuthorFulltName
END



declare @result_7 nvarchar(50)
exec @result_7 = function_7_1 
print @result_7




CREATE OR ALTER FUNCTION function_7_2()
RETURNS TABLE
AS
RETURN
 (
  Select  
  TOP(1) 
  Library.dbo.Authors.FirstName,
  Library.dbo.Authors.LastName,
  Library.dbo.Books.[Name],
  Library.dbo.Books.Quantity
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
  Inner Join Library.dbo.Authors
  ON
  Library.dbo.Authors.Id=Library.dbo.Books.Id_Author
 )




  select * from function_7_2()




-- Write a function that returns a list of books that were taken by both teachers and students. 


CREATE OR ALTER FUNCTION function_8()
RETURNS TABLE
AS
RETURN
 (
  Select
  Top(2)
  Library.dbo.Books.Id,
  Library.dbo.Books.Name
  from
  Library.dbo.Teachers 
  Inner Join Library.dbo.T_Cards
  ON
  Library.dbo.Teachers.Id=Library.dbo.T_Cards.Id_Teacher
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.T_Cards.Id_Book
  INTERSECT
  Select Distinct
  Library.dbo.Books.Id,
  Library.dbo.Books.Name
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
 )




 select * from function_8()




 -- Write a function that returns the number of students who did not take books. 


CREATE OR ALTER FUNCTION function_9_1()
RETURNS int
AS
BEGIN
  declare @count as int
  Select
  @count =Count(*) 
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
  where Library.dbo.S_Cards.DateIn is null
  RETURN @count
END




declare @result_9 int
exec @result_9 = function_9_1 
print @result_9




CREATE OR ALTER FUNCTION function_9_2()
RETURNS TABLE
AS
RETURN
 (
  Select
  Count(*) as [Count]
  from
  Library.dbo.Students 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Students.Id=Library.dbo.S_Cards.Id_Student
  Inner Join Library.dbo.Books
  ON
  Library.dbo.Books.Id=Library.dbo.S_Cards.Id_Book
  where Library.dbo.S_Cards.DateIn is null
 )




 select * from function_9_2()




 -- Write a function that returns a list of librarians and the number of books issued by each of them


CREATE OR ALTER FUNCTION function_10()
RETURNS TABLE
AS
RETURN
 (
  Select 
  Convert(nvarchar(100), COUNT(*)) + ' book given to Students'AS [book count],
  Libs.FirstName
  from
  Library.dbo.Libs 
  Inner Join Library.dbo.S_Cards
  ON
  Library.dbo.Libs.Id=Library.dbo.S_Cards.Id_Lib
  Inner Join Library.dbo.Books
  ON
  Library.dbo.S_Cards.Id_Book=Library.dbo.Books.Id
  GROUP BY 
  Libs.Id,
  Libs.FirstName
  Union ALL
  Select
  Convert(nvarchar(100), COUNT(*)) + ' book given to Teachers' AS [book count] ,
  Libs.FirstName
  from
  Library.dbo.Libs 
  Inner Join Library.dbo.T_Cards
  ON
  Library.dbo.Libs.Id=Library.dbo.T_Cards.Id_Lib
  Inner Join Library.dbo.Books
  ON
  Library.dbo.T_Cards.Id_Book=Library.dbo.Books.Id
  Group by 
  Libs.Id,
  Libs.FirstName
)


 select * from function_10()