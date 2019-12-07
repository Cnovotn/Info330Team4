-- No Player can have multiple teams, but can be in a status as 'free agent'

-- No player magnet order can have two people in the same row

-- No one team can have multiple arenas

-- Home team Id can not be the same as the away team ID

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


-- Home team and the away team cannot be the same(Chris)
CREATE FUNCTION NoSameHomeAwayTeam()
RETURNS INT
AS
    BEGIN
    DECLARE @RET INT = 0
    IF EXISTS (SELECT name
        From TEAMS t
        Join GAMES g on t.TeamID = g.HomeTeamID
        Where g.HomeTeamID = AwayTeamID
        )
    BEGIN
        SET @RET = 1
    END
RETURN @RET
END
GO

ALTER TABLE GAMES
ADD CONSTRAINT CK_NoSameHomeAwayTeam
CHECK (dbo.NoSameHomeAwayTeam() = 0)

-- Players cannot get a ‘Rookie Contract’ if they have already had a rookie contract(Chris)
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

