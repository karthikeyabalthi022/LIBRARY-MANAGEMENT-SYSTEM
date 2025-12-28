create database project_2;
use project_2;



-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

select * from tbl_publisher;

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);
select * from tbl_book;

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
     FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);
select * from tbl_book_authors;

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);
select * from tbl_library_branch;

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);
select * from tbl_book_copies;


-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY AUTO_INCREMENT,
    borrower_Name VARCHAR(255),
    borrower_Address TEXT,
    borrower_Phone VARCHAR(15)
);
select * from tbl_borrower;
-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);
select * from tbl_book_loans;

-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT b.book_Title, lb.library_branch_BranchName, bc.book_copies_No_Of_Copies
FROM tbl_book_copies bc
JOIN tbl_book b 
    ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID;
    
-- 2nd How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
    lb.library_branch_BranchName AS BranchName,
    SUM(bc.book_copies_No_Of_Copies) AS TotalCopies
FROM tbl_book_copies bc
JOIN tbl_book b 
    ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
GROUP BY lb.library_branch_BranchName;
SELECT * FROM tbl_book WHERE book_Title = 'The Lost Tribe';
SELECT * FROM tbl_book_copies WHERE book_copies_CopiesID = 20;
-- 3rd Retrieve the names of all borrowers who do not have any books checked out.
SELECT b.borrower_Name
FROM tbl_borrower b
left join tbl_book_loans bl 
    ON b.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_CardNo IS NULL; 

-- 4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

UPDATE tbl_book_loans
SET book_loans_BookID = 2;
SELECT 
    b.book_Title,
    br.borrower_Name,
    br.borrower_Address,
    bl.book_loans_DueDate
FROM tbl_book_loans bl
JOIN tbl_book b
    ON bl.book_loans_BookID = b.book_BookID
JOIN tbl_borrower br
    ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN tbl_library_branch lb
    ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Sharpstown'
  AND bl.book_loans_DueDate BETWEEN '2018-02-01' AND '2018-02-28';
UPDATE tbl_book_loans
SET book_loans_DueDate = '2018-02-03'
WHERE book_loans_BranchID = 1;

-- 5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT 
    lb.library_branch_BranchName AS BranchName,
    COUNT(bl.book_loans_LoansID) AS TotalLoans
FROM tbl_library_branch lb
LEFT JOIN tbl_book_loans bl
    ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchName;

-- 6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT 
    br.borrower_Name,
    br.borrower_Address,
    COUNT(bl.book_loans_LoansID) AS TotalBooksCheckedOut
FROM tbl_borrower br
JOIN tbl_book_loans bl 
    ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY 
    br.borrower_CardNo,
    br.borrower_Name,
    br.borrower_Address
HAVING COUNT(bl.book_loans_LoansID) > 5;

-- 7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT book_BookID, book_Title
FROM tbl_book;
UPDATE tbl_book_authors
SET book_authors_BookID = 2
WHERE book_authors_AuthorName = 'Stephen King';
SELECT library_branch_BranchID
FROM tbl_library_branch
WHERE library_branch_BranchName = 'Central';
UPDATE tbl_book_copies
SET 
    book_copies_BookID = 2,
    book_copies_BranchID = 2
WHERE book_copies_BookID IS NULL;
SELECT * FROM tbl_book_authors;
SELECT * FROM tbl_book_copies;
SELECT 
    b.book_Title,
    SUM(bc.book_copies_No_Of_Copies) AS NumberOfCopies
FROM tbl_book_authors ba
JOIN tbl_book b
    ON ba.book_authors_BookID = b.book_BookID
JOIN tbl_book_copies bc
    ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
  AND lb.library_branch_BranchName = 'Central'
GROUP BY b.book_Title;









