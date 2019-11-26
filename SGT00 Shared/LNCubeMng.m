//
//  LNCubeMng.m
//  SGT00
//
//  Created by lunafish on 13/01/2019.
//  Copyright © 2019 lunafish. All rights reserved.
//

#import "LNCubeMng.h"
#import "LNCube.h"
#import "LNUtil.h"
#import "GameController.h"

@interface LNCubeMng()
{
    NSMutableDictionary* _meshNodes; // tile mesh dictionary
    NSInteger _width; // grid width
    NSInteger _height; // grid height
}

@end

@implementation LNCubeMng

// singlton instance
static LNCubeMng* _instance = nil;
+ (LNCubeMng*)instance { @synchronized(self) { return _instance; } }

- (id)init
{
    self = [super init];
    
     // make tile dictionary
    _meshNodes = [NSMutableDictionary dictionary];
    // set singlton instance
    _instance = self;
    // init grid value
    _width = _height = LNUtil.mapSize;

    return self;
}

// get mesh by key : NSEnum CubeMesh
- (SCNNode*)getMesh:(CubeMesh)key
{
    return [_meshNodes objectForKey:[NSString stringWithFormat:@"%ld", key]];
}

// load
- (bool)load
{
    [self loadTiles]; // load tile resouce
    
    // test
    [self makeRoom:0 y:0 size:1]; // make test room
    //
    return YES;
}

// load tile resource
- (void)loadTiles
{
    // clear tile dictionary
    [_meshNodes removeAllObjects];
    
    // load tile resource scn
    SCNScene *scene = [SCNScene sceneNamed:@"Art.scnassets/geo.scn"];
    
    // add ground tile
    SCNNode* node = [scene.rootNode childNodeWithName:@"tile" recursively:YES];
    // add dictionary : key : NSEnum CubeMesh
    [_meshNodes setObject:node forKey:[NSString stringWithFormat:@"%ld", CubeMeshTile]];
}

// make tile dictionary key string (x position : y position)
- (NSString*)makeKey:(NSInteger)x y:(NSInteger)y
{
    return [NSString stringWithFormat:@"%ld:%ld", x, y];
}

// make and add tile
- (LNCube*)make:(CubeMesh)type x:(NSInteger)x y:(NSInteger)y
{
    // find exist cube
    LNCube* cube = (LNCube*)[self childNodeWithName:[self makeKey:x y:y] recursively:YES];
    
    if(cube == nil)
    {
        // make new cube
        LNCube* cube = [[LNCube alloc] init];
        
        // set information
        cube.x = x; // x position
        cube.y = y; // y position
        cube.type = type; // cube type : NSEnum CubeMesh
        cube.categoryBitMask = CollisionMeshBitMask; // set bitmask for hittest
        [cube setName:[self makeKey:x y:y]]; // key string
        
        // set world postion
        simd_float3 pos = cube.simdWorldPosition;
        pos.x = (float)x * LNUtil.tileSize;
        pos.z = (float)y * LNUtil.tileSize;
        cube.simdWorldPosition = pos;
        //
        
        [cube copyMesh:[self getMesh:type]]; // copy cube mesh
        [self addChildNode:cube]; // add child
    }
    else
    {
        // cube exist not error
        NSLog(@"Tile exist %ld %ld", x, y);
    }
    
    return cube;
}

// get linked cube index by direction
- (bool)getIndex:(NSInteger*)x y:(NSInteger*)y dir:(Dir)dir
{
    switch(dir)
    {
        case DirUp:
            (*y)--;
            break;
        case DirDown:
            (*y)++;
            break;
        case DirLeft:
            (*x)--;
            break;
        case DirRight:
            (*x)++;
            break;
        case DirUpLeft:
            (*y)--;
            (*x)--;
            break;
        case DirUpRight:
            (*y)--;
            (*x)++;
            break;
        case DirDownLeft:
            (*y)++;
            (*x)--;
            break;
        case DirDownRight:
            (*y)++;
            (*x)++;
            break;
        default:
            break;
    }
    
    return YES;
}

// make cube use dirction
- (LNCube*)makeDir:(CubeMesh)type x:(NSInteger)x y:(NSInteger)y dir:(Dir)dir
{
    if([self getIndex:&x y:&y dir:dir])
        return [self make:type x:x y:y];

    return nil;
}

// recursive fuction for make room
- (void)recvMakeRoom:(NSInteger)x y:(NSInteger)y count:(NSInteger)count
{
    // end condition
    if(count <= 0)
        return;
    
    count--;
    // make linked cube use dir
    for(NSInteger i = 0; i < DirMax; i++)
    {
        NSInteger rx = x;
        NSInteger ry = y;
        if([self getIndex:&rx y:&ry dir:i])
        {
            [self make:CubeMeshTile x:rx y:ry];
            // recursive call
            [self recvMakeRoom:rx y:ry count:count];
        }
    }
}

// make room
- (void)makeRoom:(NSInteger)x y:(NSInteger)y size:(NSInteger)size
{
    [self recvMakeRoom:x y:y count:size];
}

- (bool)getFootPostion:(simd_float3*)postion
{
    vector_float3 up = {0, 1, 0}; // up vector
    SCNVector3 p0 = SCNVector3Make(postion->x, postion->y + up.y * HIT_RANGE, postion->z); // start point : position + HIT_RANGE(Y)
    SCNVector3 p1 = SCNVector3Make(postion->x, postion->y - up.y * HIT_RANGE, postion->z); // end point : position - HIT_RANGE(Y)
    
    // hit test check only CollisionMeshBitMask mesh
    SCNHitTestResult *hit = [[self hitTestWithSegmentFromPoint:p0 toPoint:p1 options:@{SCNHitTestBackFaceCullingKey : @(NO), SCNHitTestOptionCategoryBitMask: @(CollisionMeshBitMask), SCNHitTestIgnoreHiddenNodesKey: @NO}] firstObject];
    if(hit)
    {
        postion->y = hit.worldCoordinates.y;
        return YES;
    }
    
    return NO;
}

- (void)update:(NSTimeInterval)time
{
    
}

@end
