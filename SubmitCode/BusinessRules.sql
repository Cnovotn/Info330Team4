-- 1. Team Cannot Have More Than 15 Players
CREATE FUNCTION PlayerNoMoreThan15()
RETURNS INT 
AS
BEGIN
    DECLARE @Ret INT = 0
    IF EXISTS (
        SELECT T.TeamID, Count(THS.playerID) as PlayerCount
        FROM TEAMS T
        JOIN TEAM_HAS_PLAYERS THS ON T.TeamID = THS.TeamID
        GROUP BY T.TeamID
        HAVING PlayerCount > 15
    )
    BEGIN
        SET @Ret = 1
    END
    RETURN @Ret
END
GO

ALTER TABLE TEAM_HAS_PLAYERS WITH NOCHECK
ADD CONSTRAINT CK_PlayerNoMoreThan17
CHECK (dbo.CK_PlayerNoMoreThan17() = 0)
GO

-- 2. Home team Id can not be the same as the away team ID
CREATE FUNCTION NoSameTeamsInGame()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS(
        SELECT *
        FROM GAMES G
        WHERE G.HomeTeamID = G.AwayTeamID
    )
    BEGIN 
        SET @RET = 1
    END
    RETURN @RET
END
GO

ALTER TABLE GAMES
ADD CONSTRAINT CK_NoSameTeamsInGame
CHECK(dbo.NoSameTeamsInGame() = 0)
GO

-- 3. Players cannot get a ‘Rookie Contract’ if they have already had a rookie contract(Chris)
CREATE FUNCTION onlyOneRookieContract()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
        IF EXISTS (SELECT PlayerContractID
           From PLAYER_CONTRACT pc
           Join PLAYERS on  pc.PlayerContractID = p.PlayerContractID
           Group by pc.PlayerContractID
           Having count(pc.PlayerContractID) > 1
            )
        BEGIN
            SET @RET = 1
        END
    RETURN @RET
END
GO

ALTER TABLE GAMES
ADD CONSTRAINT CK_onlyOneRookieContract
CHECK (dbo.onlyOneRookieContract() = 0)
GO

-- 4. One player can not be on two teams at the same time.
CREATE FUNCTION PlayerOnlyOneTeam()
RETURNS INT
AS
BEGIN
DECLARE @Ret INT = 0
IF EXISTS (SELECT P.PlayerID
           FROM PLAYERS P
           JOIN TEAM_HAS_PLAYERS THP on THP.PlayerID = P.PlayerID
           JOIN TEAMS T on T.TeamID = THP.TeamID
           JOIN (SELECT THP2.PlayerID, THP2.TeamID
                 FROM TEAM_HAS_PLAYERS THP2) AS SUBQ ON SUBQ.PlayerID = P.PlayerID --- CHECK THIS
           WHERE THP.PlayerID = SUBQ.PlayerID
           AND THP.TeamID != SUBQ.TeamID)
    BEGIN
        SET @Ret = 1
    END
RETURN @Ret
END
GO

ALTER TABLE TEAM_ORDER
ADD CONSTRAINT CK_PlayerOnlyOneTeam
CHECK (dbo.PlayerOnlyOneTeam() = 0)
GO

-- 5. Each player can only sign one rookie contract
CREATE FUNCTION OnlyOneRookieContract()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (Select PlayerContractID
           From PLAYER_CONTRACTS pc
           Join PLAYERS p on pc.PlayerContractID = p.PlayerContractID
           Join PLAYER_CONTRACT_TYPES pct on pct.PlayerContractTypeID = pc.PlayerContractTypeID
           Where pct.ContractName = 'Rookie Scale Contract'
           Group by p.PlayerID
           Having count(pc.PlayerContractID) > 1)
BEGIN
SET @RET = 1
END
RETURN @RET
END
GO

ALTER TABLE GAMES
ADD CONSTRAINT CK_OnlyOneRookieContract
CHECK (dbo.onlyOneRookieContract() = 0)
GO

-- 6. Player salary cannot exceed salary cap
create function PayNoExceedCap(@SalaryCap INT)
returns INT 
as
begin 
declare @RET INT = 0
if exists (SELECT P.PlayerID
           FROM PLAYERS P
           JOIN PLAYER_CONTRACTS PC ON P.PlayerID = PC.PlayerID
           WHERE PC.Price / PC.Years > @SalaryCap)
    BEGIN
    set @RET = 1
    END
return RET
END
GO
 
ALTER TABLE Player
ADD CONSTRAINT CK_NOexceedCap
CHECK (dbo.payNoExceedCap(300000) = 0)
GO

-- 7. Team can only have one game per date
CREATE FUNCTION TeamOnlyOneGame()
RETURNS INT
AS
BEGIN
DECLARE @Ret INT = 0
IF EXISTS (
    SELECT T.TeamID, T.DATE
	FROM TEAMS T
	JOIN GAMES G ON T.TEAMID = G.HomeTeamID
	JOIN (
        SELECT T.TeamID, T.DATE
        FROM TEAMS T2
        JOIN GAMES G2 ON T2.TeamID = G2.AwayTeamID
	) as subq ON T.TeamID = subq.TeamID
	Where AwayTeamID = HomeTeamID
	And
	G.Date = G2.Date
)
    BEGIN
        SET @Ret = 1
    END
RETURN @Ret
END
GO

ALTER TABLE GAMES
ADD CONSTRAINT CK_TeamOnlyOneGame
CHECK (dbo.TeamOnlyOneGame() = 0)
GO

-- 8. Max 30 teams in the NBA
CREATE FUNCTION Max30Teams()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (
    SELECT *
    FROM TEAMS AS T
    GROUP BY T.TeamID
    HAVING Count(T.TeamID) > 30
)
    BEGIN
        SET @Ret = 1
    END
RETURN @Ret
END
GO

ALTER TABLE TEAMS
ADD CONSTRAINT CK_Max30Teams
CHECK (dbo.Max30Teams() = 0)
GO

-- 9. Max 15 teams in one conference
CREATE FUNCTION Max15TeamsConference()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (
    SELECT *
    FROM TEAMS AS T
    JOIN DIVISIONS AS D
    JOIN CONFERENCES AS C
    GROUP BY T.TeamID
    HAVING Count(T.TeamID) > 15
)
    BEGIN
        SET @Ret = 1
    END
RETURN @Ret
END
GO

ALTER TABLE TEAMS
ADD CONSTRAINT CK_Max15TeamsConference
CHECK (dbo.Max15TeamsConference() = 0)