-- 1. Insert New Player
CREATE PROCEDURE InsertNewPlayer
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@DateOfBirth DATETIME,
@EnteredLeague DATETIME,
@LeftLeague DATETIME,
@NBAID INT
AS
BEGIN TRANSACTION InsertNewPlayerRow
INSERT INTO PLAYERS(FirstName, LastName, DateOfBirth, EnteredLeague, LeftLeague, NBAID)
VALUES(@FirstName, @LastName, @DateOfBirth, @EnteredLeague, @LeftLeague, @NBAID)
COMMIT TRANSACTION InsertNewPlayerRow
GO

-- EXEC InsertNewPlayer @FirstName = 'Jeffrey', @LastName='Wang', @DateOfBirth='', @EnteredLeague='', @LeftLeague = '', @NBAID = 1

-- 2. Insert New GAME
CREATE PROCEDURE InsertNewGame
@HomeTeamName VARCHAR(50),
@AwayTeamName VARCHAR(50),
@DateOf DATETIME,
@ArenaName VARCHAR(50),
@AwayScore INT,
@HomeScore INT
AS
DECLARE @HomeID INT, @AwayID INT, @ArenaID INT
SET @ArenaID = (SELECT ArenaID FROM ARENAS WHERE ArenaName = @ArenaName)
SET @HomeID = (SELECT T.TeamID 
    FROM TEAMS T
    WHERE T.TeamName = @HomeTeamName
)
SET @AwayID = (SELECT T.TeamID 
    FROM TEAMS T
    WHERE T.TeamName = @AwayTeamName
)
BEGIN TRANSACTION InsertNewGameRow
INSERT INTO GAMES(HomeTeamID, AwayTeamId, DateOf, ArenaID, AwayScore, HomeScore)
VALUES(@HomeID, @AwayID, @DateOf, @ArenaID, @AwayScore, @HomeScore)
COMMIT TRANSACTION InsertNewGameRow
GO

-- EXEC insertNewGame @HomeTeamName = '', @AwayTeamName='', @DateOf='', @ArenaName='', @AwayScore = 10, @HomeScore = 10

-- 3. Insert New Team
create procedure InsertNewTeam
@TName varchar(20),
@City varchar(20),
@State varchar(20),
@Country varchar(20),
@DName varchar(20)
as
declare @DID int = (select d.DivisionID
                    from DIVISIONS d
                    where d.DivisionName = @DName)
BEGIN TRANSACTION InsertNewTeamRow
insert into TEAMS(Name, City, State, Country, DivisionID)
values(@TName, @City, @State, @Country, @DID)
COMMIT TRANSACTION InsertNewTeamRow
GO

-- EXEC insertNewGame @HomeTeamName = '', @AwayTeamName='', @DateOf='', @ArenaName='', @AwayScore = 10, @HomeScore = 10

-- 4. Insert New Conference
create procedure InsertNewConference
@CName varchar(7),
@CDesc varchar(500)
as
BEGIN TRANSACTION InsertNewConferenceRow
insert into CONFERENCES(ConferenceName, ConferenceDesc)
values(@CName, @CDesc)
COMMIT TRANSACTION InsertNewConferenceRow
GO

-- EXEC insertNewGame @CName = '', @CDesc = ''

-- 5. Insert New Division
create procedure InsertNewDivision
@DName varchar(20),
@DDesc varchar(500)
as
begin transaction InsertNewDivisionRow
insert into DIVISIONS(DivisionName, DivisionDesc)
values(@DName, @DDesc)
commit transaction InsertNewDivisionRow
GO

-- EXEC insertNewDivision @DName = '', @DDesc = ''

-- 6. Insert New Arena 
create procedure InsertNewArena
@AName varchar(20),
@ANickname varchar(20),
@Address varchar(20),
@Capacity int,
@City varchar(20),
@State varchar(20),
@Country varchar(20)
as
begin transaction InsertNewArenaRow
insert into ARENAS(ArenaName, ArenaNickname, Address, Capacity, City, State, Country)
values(@AName, @ANickname, @Address, @Capacity, @City, @State, @Country)
commit transaction InsertNewArenaRow
GO

-- EXEC insertNewGame @AName = '', @ANickname = '', @Address, @Capacity, @City, @State, @Country)

-- 7. Insert New Contract Type
-- https://cbabreakdown.com/contract-types
CREATE PROCEDURE InsertNewContractType
    @ContractName varchar(100),
    @ContractDesc text
    AS
    BEGIN TRANSACTION InsertNewContractTypeRow
    INSERT INTO PLAYER_CONTRACT_TYPES(ContractName, ContractDesc)
    VALUES(@ContractName, @ContractDesc)
    COMMIT TRANSACTION InsertNewContractTypeRow
GO

-- EXEC InsertContractType @ContractName = '', @ContractDesc = ''

-- 8. Insert New Contract
CREATE PROCEDURE InsertNewContract
    @Price NUMERIC(10,2),
    @Years INT,
    @BeginDate DATETIME,
    @EndDate DATETIME,
    @ContractTypeName VARCHAR(100),
    @PlayerFirstName VARCHAR(100),
    @PlayerLastName VARCHAR(100),
    @PlayerDOB DATETIME
    AS
    DECLARE @PlayerID INT, @ContractTypeID INT
    SET @PlayerID = (
        SELECT PlayerID 
        FROM PLAYERS
        WHERE FirstName = @PlayerFirstName AND LastName = @PlayerLastName AND DateOfBirth = @PlayerDOB
    )
    SET @ContractTypeID = (
        SELECT PlayerContractTypeID
        FROM PLAYER_CONTRACT_TYPES
        WHERE ContractName = @ContractTypeName
    )
    BEGIN TRANSACTION InsertNewContractRow
    INSERT INTO PLAYER_CONTRACTS(Price, Years, BeginDate, EndDate, ContractTypeID, PlayerID)
    VALUES(@Price, @Years, @BeginDate, @EndDate, @ContractTypeID, PlayerID)
    COMMIT TRANSACTION InsertNewContractRow
GO

-- EXEC InsertNewContract @Price = '', @Years = '', @BeginDate = '', @EndDate = '', @ContractTypeName = '', @PlayerFirstName = 'Jeffrey', @PlayerLastName = 'Wang', @PlayerDOB = ''

-- 9. Insert New Player Game Stat
Create Procedure InsertNewPlayerGameStat
	@playerID int,
	@gameID int,
	@statName varchar(45)
	As
	Declare @PGSTID int
	SET @PGSTID =(Select PlayerGameStatTypeID FROM PLAYER_GAME_STAT_TYPES WHERE StatName = @statName)
BEGIN TRANSACTION InsertPalyerGameStatRow
Insert into PLAYER_GAME_STATS(PlayerID, GameID,PlayerGameStatTypeID)
Values(@playerID, @gameID, @PGSTID)
COMMIT TRANSACTION InsertPlayerGameStatRow
GO

-- EXEC InsertNewPlayerGameStat @playerID = '', @gameID = '', @statName = ''

-- 10. Insert New Team Has Players
CREATE PROCEDURE InsertNewPlayerTeam
@TeamName VARCHAR(100),
@TeamState VARCHAR(50),
@PlayerFirstName VARCHAR(100),
@PlayerLastName VARCHAR(100),
@PlayerDOB DATETIME,
@DateJoined DATETIME
AS
DECLARE @PlayerID INT, @TeamID INT
    SET @PlayerID = (
        SELECT PlayerID 
        FROM PLAYERS
        WHERE FirstName = @PlayerFirstName AND LastName = @PlayerLastName AND DateOfBirth = @PlayerDOB
    )
    SET @TeamID = (
        SELECT TeamID
        FROM TEAMS
        WHERE Name = @TeamName AND State = @TeamState
    )
BEGIN TRANSACTION InsertNewPlayerTeamRow
INSERT INTO TEAM_HAS_PLAYERS(TeamID, PlayerID, DateJoined)
VALUES(@TeamID, @PlayerID, @DateJoined)
COMMIT TRANSACTION InsertNewPlayerTeamRow
GO

-- EXEC InsertNewPlayerGameStat @TeamName = '', @TeamState = '', @PlayerFirstName = '', @PlayerLastName = '', @PlayerDOB = '', @DateJoined = ''
