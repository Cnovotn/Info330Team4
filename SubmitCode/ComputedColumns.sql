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

CREATE FUNCTION ComputeTotal3PointersInGame(@GameID INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT
    SET @RET = (
        SELECT PGS.TotalOfStat
        FROM PLAYER_GAME_STATS PGS
            JOIN PLAYER P ON PGS.PlayerID = P.PlayerID
            JOIN GAMES G ON PGS.GameID = G.GameID
            JOIN PLAYER_GAME_STATS_TYPE PGST ON PGS.PlayerGameStatTypeID = PGST.PlayerGameStatTypeID
            WHERE PGST.StatName = '3pt' AND PGS.GameID = @GameID
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

CREATE FUNCTION ComputeAverageORBPerGame(@playerID INT)
RETURNS INT
AS
BEGIN
	DECLARE @RET INT
	SET @RET = (
		SELECT AVG(PGST.StatValue)
		FROM PLAYER_GAME_STATS PGS
		JOIN PLATER_GAME_STATS_TYPE PGST ON PGS.PlayerGameStatTypeID = PGST.PlayerGameStatTypeID
        WHERE PGST.StatName = 'ORB'
            AND 
            PGS.PlayerID = @playerID
            GROUP BY PGS
        )
        RETURN @RET
END
GO

ALTER TABLE PLAYERS
ADD ORBPerGame AS (dbo.ComputeORBPerGame(PlayerID))
GO