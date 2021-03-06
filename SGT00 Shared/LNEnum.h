//
//  LNEnum.h
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#ifndef LNEnum_h
#define LNEnum_h

#define HIT_RANGE 8
#define CollisionMeshBitMask 8

// animation string
static NSString* const ROOTANI = @"RootAni"; // root ani node
static NSString* const ROOTANIBONE = @"RootAniBone"; // root animation bone
static NSString* const ROOTANI00 = @"rootAni00"; // short knockback root animation
static NSString* const PUPPET = @"puppet"; // Puppet mesh
static NSString* const PUPPETIDLE = @"puppetIdle"; // Puppet Idle Animation
static NSString* const PUPPETATTACK = @"puppetAttack"; // Puppet Attack Animation
static NSString* const PUPPETSHORTKB = @"puppetShortKnockback"; // Short Knockback
static NSString* const PUPPETBONE = @"Bone"; // root animation bone

// HUD string
static NSString* const BUTTONDOWN = @"SKBtnDown";
static NSString* const BUTTONMOVE = @"SKBtnMove";
static NSString* const LABELSTATE = @"SKLabelState";
static NSString* const LABELLog = @"SKLabelLog";

// Direction
typedef NS_ENUM(NSInteger, Dir)
{
    DirCenter = 0,
    DirUp,
    DirUpLeft,
    DirLeft,
    DirDownLeft,
    DirDown,
    DirDownRight,
    DirRight,
    DirUpRight,
    DirMax,
};

// Path type
typedef NS_ENUM(NSInteger, PathType)
{
    PathTypeRect = 0,
    PathTypeShort,
    PathTypeMax,
};

// Cube tag
typedef NS_ENUM(NSInteger, CubeTag)
{
    CubeTagNone = 0,
    CubeTagSTART,
    CubeTagEND,
    CubeTagSpawn,
    CubeTagMAX,
};

// Cube Mesh Type
typedef NS_ENUM(NSInteger, CubeMesh)
{
    CubeMeshTile = 1,
    CubeMeshMax,
};

// Cube State
typedef NS_ENUM(NSInteger, CubeStat)
{
    CubeStatNone = 0,
    CubeStatGreen,
    CubeStatYellow,
    CubeStatRed,
    CubeStatMax,
};

// LNNode Type
typedef NS_ENUM(NSInteger, NodeType)
{
    NodeTypeNone = 0,
    NodeTypeCube,
    NodeTypePlayer,
    NodeTypeEnemy,
    NodeTypeFriend,
    NodeTypeNPC,
    NodeTypeBot,
    NodeTypeBullet,
};

typedef NS_ENUM(NSInteger, TeamType)
{
    TeamNone = 0,
    TeamRed,
    TeamBlue,
};

typedef NS_ENUM(NSInteger, BTNodeType)
{
    BTNodeSequence = 0,
    BTNodeTask,
};

typedef NS_ENUM(NSInteger, BTTaskType)
{
    BTTaskNone = 0,
    BTTaskFailed,
    BTTaskSuccess,
    BTTaskProcess,
};

typedef NS_ENUM(NSInteger, BulletType)
{
    BulletRange = 0,
    BulletMelee
};
#endif /* LNEnum_h */
