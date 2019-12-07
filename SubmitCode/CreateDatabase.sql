USE Proj_C4;
CREATE TABLE USERS(
    UserID INT IDENTITY(1,1) primary key not null,
    FirstName varchar(45) not null,
    LastName varchar(45) not null,
    UserName varchar(45) not null,
    Password varchar(245) not null,
    Email varchar(245) not null,
    CreatedAt DATETIME not null,
    UpdatedAt DATETIME not null
);
CREATE TABLE TEAM_ORDER(
    TeamOrderID INT IDENTITY(1,1) primary key not null,
    UserID INT FOREIGN KEY REFERENCES USERS(UserID) not null,
    TeamID INT FOREIGN KEY REFERENCES TEAMS(TeamID) not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    PlayerTeamOrder INT
);
CREATE TABLE PLAYERS(
    PlayerID INT IDENTITY(1,1) primary key not null,
    FirstName varchar(45) not null,
    LastName varchar(45) not null,
    DateOfBirth DATETIME not null,
    EnteredLeague DATETIME not null,
    LeftLeague DATETIME null,
    NBAID INT
);
CREATE TABLE CONFERENCES(
    ConferenceID INT IDENTITY(1,1) primary key not null,
    ConferenceName varchar(45) not null,
    ConferenceDesc text,
);
CREATE TABLE DIVISIONS(
    DivisionID INT IDENTITY(1,1) primary key not null,
    DivisionName varchar(45) not null,
    DivisionDesc text,
    ConferenceID INT FOREIGN KEY REFERENCES CONFERENCES(ConferenceID) not null
);
CREATE TABLE TEAMS(
    TeamID INT IDENTITY(1,1) primary key not null,
    Name varchar(45) not null,
    City varchar(45) not null,
    State varchar(45) not null,
    Country varchar(45) not null,
    DivisionID INT FOREIGN KEY REFERENCES DIVISIONS(DivisionID) not null,
    NBAID INT
);
CREATE TABLE ARENAS(
    ArenaID INT IDENTITY(1,1) primary key not null,
    ArenaName varchar(45) not null,
    ArenaNickName varchar(45) not null,
    Address varchar(245) not null,
    Capacity INT,
    City varchar(45) not null,
    State varchar(45) not null,
    Country varchar(45) not null
);
CREATE TABLE ARENA_HAS_TEAMS(
    ArenaID INT FOREIGN KEY REFERENCES ARENAS(ArenaID) not null,
    TeamID INT FOREIGN KEY REFERENCES TEAMS(TeamID) not null
);
CREATE TABLE PLAYER_POSITIONS(
    PlayerPositionID INT IDENTITY(1,1) primary key not null,
    PositionName varchar(45) not null,
    PositionAbbreviation varchar(5) not null,
    PositionDesc text
);
CREATE TABLE PLAYER_HAS_POSITIONS(
    PlayerHasPositionsID INT IDENTITY(1,1) PRIMARY KEY not null,
    PlayerPositionID INT FOREIGN KEY REFERENCES PLAYER_POSITIONS(PlayerPositionID) not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    DateStarted DATETIME,
    DateEnded DATETIME
);
CREATE TABLE PLAYER_STATUS_TYPES(
    PlayerStatusTypeID INT IDENTITY(1,1) primary key not null,
    StatusName varchar(45) not null,
    StatusDesc text
);
CREATE TABLE PLAYER_STATUS(
    PlayerStatusID INT IDENTITY(1,1) primary key not null,
    StartDate DATETIME not null,
    EndDate DATETIME NULL,
    PlayerStatusTypeID INT FOREIGN KEY REFERENCES PLAYER_STATUS_TYPES(PlayerStatusTypeID) not null
);
CREATE TABLE PLAYER_TRAIT_TYPES(
    PlayerTraitTypeID INT IDENTITY(1,1) PRIMARY KEY not null,
    TraitTypeName varchar(50) not null,
    TraitTypeLabel varchar(50),
    TraitTypeDesc text
)
CREATE TABLE PLAYER_TRAITS(
    PlayerTraitsID INT IDENTITY(1,1) primary key not null,
    DateTaken DATETIME not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    PlayerTraitTypeID INT FOREIGN KEY REFERENCES PLAYER_TRAIT_TYPES(PlayerTraitTypeID) not null,
    TraitValue INT not null
);
CREATE TABLE PLAYER_CONTRACT_TYPES(
    PlayerContractTypeID INT IDENTITY(1,1) primary key not null,
    ContractName varchar(45),
    ContractDesc varchar(45)
);
CREATE TABLE PLAYER_CONTRACTS(
    PlayerContractID INT IDENTITY(1,1) primary key not null,
    Price INT not null,
    Years INT not null,
    BeginDate DATETIME not null ,
    EndDate DATETIME null,
    PlayerContractTypeID INT FOREIGN KEY REFERENCES PLAYER_CONTRACT_TYPES(PlayerContractTypeID)
);
CREATE TABLE COLLEGES(
    CollegeID INT IDENTITY(1,1) primary key not null,
    CollegeName varchar(245) not null,
    Mascot varchar(45),
    City varchar(45) not null,
    State varchar(45) not null,
    Country varchar(45) not null,
    ConferenceID INT FOREIGN KEY REFERENCES CONFERENCES(ConferenceID) not null
);
CREATE TABLE PLAYER_HAS_COLLEGES(
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    CollegeID INT FOREIGN KEY REFERENCES COLLEGES(CollegeID) not null,
    BeginDate DATETIME not null,
    EndDate DATETIME not null
);
CREATE TABLE PLAYER_CLIP_TYPES(
    PlayerClipTypeID INT IDENTITY(1,1) primary key not null,
    ClipTypeName varchar(45) not null,
    ClipTypeDesc text
);
CREATE TABLE PLAYER_CLIPS(
    PlayerClipID INT IDENTITY(1,1) primary key not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    GameID INT FOREIGN KEY REFERENCES GAMES(GameID) not null,
    PlayerClipTypeID INT FOREIGN KEY REFERENCES PLAYER_CLIP_TYPES(PlayerClipTypeID) not null,
    ClipLink varchar(245) not null
);
CREATE TABLE GAMES(
    GameID INT IDENTITY(1,1) primary key not null,
    HomeTeamID INT FOREIGN KEY REFERENCES TEAMS(TeamID) not null,
    AwayTeamID INT FOREIGN KEY REFERENCES TEAMS(TeamID) not null,
    DateOf DATETIME not null,
    ArenaID INT FOREIGN KEY REFERENCES ARENAS(ArenaID) not null,
    AwayScore INT not null,
    HomeScore INT not null
)
CREATE TABLE PLAYER_GAME_STAT_TYPES(
    PlayerGameStatTypeID INT IDENTITY(1,1) PRIMARY KEY not null,
    StatName varchar(45) not null,
    StatDesc text,
    StatValue INT
);
CREATE TABLE PLAYER_GAME_STATS(
    PlayerGameStatsID INT IDENTITY(1,1) primary key not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    GameID INT FOREIGN KEY REFERENCES GAMES(GameID) not null,
    PlayerGameStatTypeID INT FOREIGN KEY REFERENCES PLAYER_GAME_STAT_TYPES(PlayerGameStatTypeID) not null
);
CREATE TABLE TEAM_HAS_PLAYERS(
    TeamID INT FOREIGN KEY REFERENCES TEAMS(TeamID) not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null,
    DateJoined DATETIME
);
CREATE TABLE PLAYER_PLAYS_GAMES(
    GameID INT FOREIGN KEY REFERENCES GAMES(GameID) not null,
    PlayerID INT FOREIGN KEY REFERENCES PLAYERS(PlayerID) not null
);

