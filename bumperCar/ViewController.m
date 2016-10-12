//
//  ViewController.m
//  bumperCar
//
//  Created by enghou on 16/10/10.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

#import "ViewController.h"
#import "bumperCar.h"
#import "bumperRink.h"
#import "ObjectMesh.h"
@interface ViewController ()
@property(nonatomic,strong)GLKBaseEffect *baseEffect;
- (IBAction)lookat:(id)sender;
@end

@implementation ViewController
{
    ObjectMesh *car;
    ObjectMesh *rink;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *view=(GLKView *)self.view;
    view.context=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    _baseEffect=[[GLKBaseEffect alloc]init];
    _baseEffect.light0.enabled=GL_TRUE;
    self.baseEffect.light0.position = GLKVector4Make(
                                                     1.0f,
                                                     0.8f, 
                                                     0.4f,  
                                                     0.0f);
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.6f, // Red
                                                         0.6f, // Green
                                                         0.6f, // Blue 
                                                         1.0f);
    glClearColor(0, 0, 0, 1);
    glEnable(GL_DEPTH_TEST);
    NSMutableData *data=[NSMutableData data];
    for (int i=0; i<bumperCarNumVerts; i++) {
        ObjectMeshVertex mesh;
        mesh.position.x=bumperCarVerts[i*3];
        mesh.position.y=bumperCarVerts[i*3+1];
        mesh.position.z=bumperCarVerts[i*3+2];
        mesh.normal.x=bumperCarNormals[i*3];
        mesh.normal.y=bumperCarNormals[i*3+1];
        mesh.normal.z=bumperCarNormals[i*3+2];
        [data appendBytes:&mesh length:sizeof(mesh)];
    }
    NSMutableData *rinks=[NSMutableData data];
    for (int i=0; i<bumperRinkNumVerts; i++) {
        ObjectMeshVertex mesh;
        mesh.position.x=bumperRinkVerts[i*3];
        mesh.position.y=bumperRinkVerts[i*3+1];
        mesh.position.z=bumperRinkVerts[i*3+2];
        mesh.normal.x=bumperRinkNormals[i*3];
        mesh.normal.y=bumperRinkNormals[i*3+1];
        mesh.normal.z=bumperRinkNormals[i*3+2];
        [rinks appendBytes:&mesh length:sizeof(mesh)];
    }

    car=[[ObjectMesh alloc]initWithVertexData:data Indices:nil];
    rink=[[ObjectMesh alloc]initWithVertexData:rinks Indices:nil];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
                                                         1.0f, // Red
                                                         1.0f, // Green
                                                         1.0f, // Blue 
                                                         1.0f);
    GLfloat aspect = (GLfloat)view.drawableWidth/(GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix=GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35), aspect, 0.1, 25);
    self.baseEffect.transform.modelviewMatrix=GLKMatrix4MakeLookAt(10.5, 5.0, 0, 0, 0.5, 0, 0, 1, 0);
    [_baseEffect prepareToDraw];
    [rink prepareToDraw];
    [rink draw];
    [car prepareToDraw];
    [car draw];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)lookat:(id)sender {
    self.baseEffect.transform.modelviewMatrix=GLKMatrix4MakeLookAt(0, 25, 0, 0, 0, -10, 0, 1, 0);
}
@end
