//
//  EAAOpenGLView.m
//  EAAOpenGLOSXLab1
//
//  Created by Андрей Ежов on 09.05.16.
//  Copyright © 2016 Ezhov Andrey. All rights reserved.
//

#import "EAAOpenGLView.h"
#import <GLUT/GLUT.h>
#import <GLKit/GLKit.h>


@implementation EAAOpenGLView {
    
    float ax, ay, dx, dy, dz;
    short posX, posY;
    bool leftButton, twoSide;
}

float color[3] = {0.1, 0.6, 0.1 };
float v[8][3] = { -1, 1, -1, 1, 1, -1, 1, -1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, 1, -1, 1, 1, 1, 1 };
float norm[6][3] = { 0, 0, -1, 0, 0, 1, -1, 0, 0, 1, 0, 0, 0, 1, 0, 0, -1, 0 };
int idx[6][4] =
{
    0, 1, 2, 3,	// Rear (CCW - counterclockwise)
    4, 5, 6, 7,	// Front
    0, 3, 5, 4,	// Left
    7, 6, 2, 1,	// Right
    0, 4, 7, 1,	// Top
    5, 3, 2, 6,	// Bottom
};



- (void) prepareOpenGL {

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glLoadMatrixf( GLKMatrix4MakePerspective(45,1,1.0f,1000.0f).m);
    
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glEnable(GL_DEPTH_TEST);
    
    glClearColor(1, 1, 1, 0);

    glShadeModel(GL_FLAT);
    
    glEnable(GL_POINT_SMOOTH);
    
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);

    
    ax = 10;
    ay = 10;
    dz = -6;
}


- (void) drawRect:(NSRect)rect {
    [super drawRect:rect];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_MODELVIEW); 	// Будем пользоваться услугами MM
    glLoadIdentity();
    glTranslatef(dx, dy, dz); // Смещение координат точек будущих примитивов
    glRotatef(ay, 0, 1, 0); 	// Вращение координат точек примитивов
    glRotatef(ax, 1, 0, 0);
    
    glColor3fv(color);
    glBegin(GL_QUADS);		// Выбор типа примитива
    for (int i = 0; i < 6; i++)	// Долго готовились - быстро рисуем
    {
        glNormal3fv(norm[i]);
        for (int j = 0; j < 4; j++)
            glVertex3fv(v[idx[i][j]]);
    }
    glEnd();
    glFlush();
    
}

- (void) keyDown:(NSEvent *)theEvent {

    switch (theEvent.keyCode) {
        case 126:
            ax+=5;
            break;
        case 125:
            ax-=5;
            break;
        case 123:
            ay+=5;
            break;
        case 124:
            ay-=5;
            break;
        case 50:
            dz+=0.1;
            break;
        case 6:
            dz-=0.1;
            break;
        default:
            break;
    }
    [self setNeedsDisplay:YES];
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

@end
