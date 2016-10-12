//
//  ObjectMesh.h
//  bumperCar
//
//  Created by enghou on 16/10/12.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

#import <GLKit/GLKit.h>
typedef struct {
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector2 texCoords0;
}ObjectMeshVertex;
@interface ObjectMesh : NSObject
-(id)initWithPositionData:(GLfloat *)data normalData:(GLfloat *)normal texCoordsData:(GLfloat *)texCoords vertexCount:(GLsizei)count indexData:(GLfloat *)indices indicesCount:(GLsizei)indiceCount;

-(id)initWithVertexData:(NSData *)data Indices:(NSData *)indices;

-(void)prepareToDraw;

-(void)draw;




@end
