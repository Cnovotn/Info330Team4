CREATE FUNCTION ComputeTotalStatType(@GameID INT, @StatType VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @RET INT
    SET @RET = (
        SELECT SUM(PGST.StatValue) 
        FROM PLAYER_GAME_STATS PGS
        JOIN PLAYER_GAME_STATS_TYPE PGST ON PGS.PlayerGameStatTypeID = PGST.PlayerGameStatTypeID
        WHERE PGST.StatName = @StatType AND PGS.GameID = @GameID
        GROUP BY PGS
    )
    RETURN @RET
END 
GO

ALTER TABLE GAMES
ADD Total3PointersMade AS (dbo.ComputeTotalStatType(GameID, '3Made'))
ALTER TABLE GAMES
ADD Total3PointersMissed AS (dbo.ComputeTotalStatType(GameID, '3Missed'))
ALTER TABLE GAMES
ADD Total2PointersMade AS (dbo.ComputeTotalStatType(GameID, '2Made'))
ALTER TABLE GAMES
ADD Total2PointersMissed AS (dbo.ComputeTotalStatType(GameID, '2Missed'))
GO

CREATE FUNCTION ComputeTotalHomeFouls(@GameID INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT
    SET @RET = (
        SELECT Count(PGS.PlayerGameStatID) 
        FROM PLAYER_GAME_STATS PGS
        JOIN PLAYER_GAME_STATS_TYPE PGST ON PGS.PlayerGameStatTypeID = PGST.PlayerGameStatTypeID
        WHERE PGST.StatName = 'Foul' AND PGS.GameID = @GameID 
    )
    RETURN @RET
END 
GO