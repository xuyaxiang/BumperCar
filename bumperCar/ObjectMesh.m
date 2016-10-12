//
//  ObjectMesh.m
//  bumperCar
//
//  Created by enghou on 16/10/12.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

#import "ObjectMesh.h"
@interface ObjectMesh()
@property(nonatomic,strong)NSData *indicesData;
@property(nonatomic,assign)GLsizei vertsNum;
@property(nonatomic,assign)GLsizei indiceCount;
@property(nonatomic,assign)GLuint name;
@property(nonatomic,assign)GLuint index;
@end
@implementation ObjectMesh
@synthesize name;
@synthesize index;
-(id)initWithVertexData:(NSData *)data Indices:(NSData *)indices{
    self=[super init];
    if(self){
        glGenBuffers(1, &name);
        glBindBuffer(GL_ARRAY_BUFFER, name);
        _vertsNum=(GLsizei)data.length/sizeof(ObjectMeshVertex);
        glBufferData(GL_ARRAY_BUFFER, data.length, data.bytes, GL_STATIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        if(indices){
            glGenBuffers(GL_ELEMENT_ARRAY_BUFFER, &index);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length, indices.bytes, GL_STATIC_DRAW);
        }
    }
    return self;
}

-(id)initWithPositionData:(GLfloat *)data normalData:(GLfloat *)normal texCoordsData:(GLfloat *)texCoords vertexCount:(GLsizei)count indexData:(GLfloat *)indices indicesCount:(GLsizei)indiceCount{
    if(nil==data || nil ==normal){
        return nil;
    }
    NSMutableData *vert=[NSMutableData data];
    NSData *indicedata;
    for(int i=0;i<count;++i){
        ObjectMeshVertex meshVertex;
        meshVertex.position.x=data[i*3];
        meshVertex.position.y=data[i*3+1];
        meshVertex.position.z=data[i*3+2];
        meshVertex.normal.x=normal[i*3];
        meshVertex.normal.y=normal[i*3+1];
        meshVertex.normal.z=normal[i*3+2];
        if(texCoords){
            meshVertex.texCoords0.s=texCoords[2*i];
            meshVertex.texCoords0.t=texCoords[2*i+1];
        }else{
            meshVertex.texCoords0.s=0;
            meshVertex.texCoords0.t=0;
        }
        [vert appendBytes:&meshVertex length:sizeof(meshVertex)];
    }
    indicedata=[NSData dataWithBytes:indices length:sizeof(GLfloat)*indiceCount];
    return [self initWithVertexData:vert Indices:indicedata];
}

-(void)prepareToDraw{
    glBindBuffer(GL_ARRAY_BUFFER, name);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(ObjectMeshVertex), NULL+offsetof(ObjectMeshVertex, position));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(ObjectMeshVertex), NULL+offsetof(ObjectMeshVertex, normal));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(ObjectMeshVertex), NULL+offsetof(ObjectMeshVertex, texCoords0));
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)draw{
    if(_indicesData){
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
        glDrawElements(GL_TRIANGLES, (GLsizei)_indicesData.length/sizeof(GLfloat), GL_UNSIGNED_SHORT, _indicesData.bytes);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }else{
        glBindBuffer(GL_ARRAY_BUFFER, name);
        glDrawArrays(GL_TRIANGLES, 0, _vertsNum);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }
}
@end
