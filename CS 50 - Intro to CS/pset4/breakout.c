//
// breakout.c
//
// Computer Science 50
// Problem Set 4
//

// standard libraries
#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Stanford Portable Library
#include "gevents.h"
#include "gobjects.h"
#include "gwindow.h"

// height and width of game's window in pixels
#define HEIGHT 600
#define WIDTH 400

// number of rows of bricks
#define ROWS 5

// number of columns of bricks
#define COLS 10

// radius of ball in pixels
#define RADIUS 10

// lives
#define LIVES 3

// paddle width and height
#define PADDLE_WIDTH 60
#define PADDLE_HEIGHT 15

#define LIFETIME 500

// brick height and width
double brick_height = HEIGHT * 0.2 / ROWS;
double brick_width = WIDTH / COLS;
double paddle_gap =  HEIGHT - (.05 * HEIGHT);

// prototypes
void initBricks(GWindow window);
GOval initBall(GWindow window);
GRect initPaddle(GWindow window);
GLabel initScoreboard(GWindow window);
void updateScoreboard(GWindow window, GLabel label, int points);
GObject detectCollision(GWindow window, GOval ball);

int main(void)
{
    // seed pseudorandom number generator
    srand48(time(NULL));

    // instantiate window
    GWindow window = newGWindow(WIDTH, HEIGHT);

    // instantiate bricks
    initBricks(window);

    // instantiate ball, centered in middle of window
    GOval ball = initBall(window);

    // instantiate paddle, centered at bottom of window
    GRect paddle = initPaddle(window);

    // instantiate scoreboard, centered in middle of window, just above ball
    GLabel label = initScoreboard(window);

    // number of bricks initially
    int bricks = COLS * ROWS;

    // number of lives initially
    int lives = LIVES;

    // number of points initially
    int points = 0;

    // sets velocity of ball
    double velocity = (drand48() + 2);
    double velocity_y = velocity;
    double velocity_x = (drand48() + drand48() + 1);
    
    waitForClick();
    
    while (lives > 0 && bricks > 0)
    {
        // move paddle with mouse
        GEvent event = getNextEvent(MOUSE_EVENT);
        if (event != NULL)
        {
            if (getEventType(event) == MOUSE_MOVED)
            {
                // initiates x and y to current values
                double x = getX(paddle);
                double y = getY(paddle);
                
                // if paddle is off the screen
                bool left_bound = getX(event) <= PADDLE_WIDTH / 2;
                bool right_bound = getX(event) >= WIDTH - PADDLE_WIDTH / 2;
                
                // if paddle is within boundaries update x
                if (!(left_bound || right_bound))
                    x = getX(event) - PADDLE_WIDTH / 2;
                    
                // sets new location of paddle
                setLocation(paddle, x, y);
            }
        }
        // moves ball
        move(ball, velocity_x, velocity_y);

        // tests if ball is within boundaries
        bool paddle_bound = getY(ball) + getWidth(ball) > paddle_gap;
        bool brick_bound = getY(ball) <= brick_height * ROWS;
       
        GObject object = detectCollision(window, ball);
        if (object != NULL)
        {
            // bounce off paddle
            if (object == paddle)
            {
                velocity_y = -velocity_y;
            }
            // bounce off bricks
            else if (brick_bound)
            {
                if (strcmp(getType(object), "G3DRect") == 0)
                {
                    velocity_y = -velocity_y;
                    removeGWindow(window, object);
                    bricks--;
                    points++;
                    updateScoreboard(window, label, points);
                }   
                else 
                {
                    velocity_y = -velocity_y;
                }
            }
                  
        }
        // bounce off edge of window
        else if (getX(ball) + getWidth(ball) >= WIDTH || getX(ball) <= 0)
        {
            velocity_x = -velocity_x;
            
        }
        else if (getY(ball) <= 0)
        {
            velocity_y = -velocity_y;
        }
        else if (getY(ball) >= HEIGHT && lives > 0)
        {
            setLocation(ball, WIDTH / 2 - 20, HEIGHT / 2 + 10);
            lives--;
            pause(LIFETIME);
        }
        // linger before moving again
        pause(10);
        
    }
    // wait for click before exiting
    waitForClick();

    // game over
    closeGWindow(window);
    return 0;
}

/**
 * Initializes window with a grid of bricks.
 */
void initBricks(GWindow window)
{
    // creates bricks
    for (int row = 0; row < ROWS; row++)
    {
        for (int col = 0; col < COLS; col++)
        {
            // brick coordinates
            double x = (brick_width * col);
            double y = (brick_height * row);
            
            G3DRect brick = newG3DRect(x, y, brick_width, brick_height, true);
            setFilled(brick, true);
            setColor(brick, "RED");
            add(window, brick);
        }
    }
}

/**
 * Instantiates ball in center of window.  Returns ball.
 */
GOval initBall(GWindow window)
{
    double diameter = 20;
    double radius = diameter / 2;
    GOval ball = newGOval(WIDTH / 2 - diameter, HEIGHT / 2 + radius, 20, 20);
    setColor(ball, "BLACK");
    setFilled(ball, true);
    add(window, ball);
    return ball;
}

/**
 * Instantiates paddle in bottom-middle of window.
 */
G3DRect initPaddle(GWindow window)
{
    double x = (WIDTH / 2) - (PADDLE_WIDTH / 2);
    double y = paddle_gap;
    G3DRect paddle = newG3DRect(x, y, PADDLE_WIDTH, PADDLE_HEIGHT, true);
    setFilled(paddle, true);
    setColor(paddle, "GRAY");
    add(window, paddle);
    return paddle;
}

/**
 * Instantiates, configures, and returns label for scoreboard.
 */
GLabel initScoreboard(GWindow window)
{
    GLabel label = newGLabel("");
    setColor(label, "LIGHT_GRAY");
    setFont(label, "SansSerif-48");
    add(window, label);
    sendToBack(label);
    updateScoreboard(window, label, 0);
    return label;
}

/**
 * Updates scoreboard'ks label, keeping it centered in window.
 */
void updateScoreboard(GWindow window, GLabel label, int points)
{
    // update label
    char s[12];
    sprintf(s, "%i", points);
    setLabel(label, s);

    // center label in window
    double x = (getWidth(window) - getWidth(label)) / 2;
    double y = (getHeight(window) - getHeight(label)) / 2;
    setLocation(label, x, y);
}

/**
 * Detects whether ball has collided with some object in window
 * by checking the four corners of its bounding box (which are
 * outside the ball's GOval, and so the ball can't collide with
 * itself).  Returns object if so, else NULL.
 */
GObject detectCollision(GWindow window, GOval ball)
{
    // ball's location
    double x = getX(ball);
    double y = getY(ball);

    // for checking for collisions
    GObject object;

    // check for collision at ball's top-left corner
    object = getGObjectAt(window, x, y);
    if (object != NULL)
    {
        return object;
    }

    // check for collision at ball's top-right corner
    object = getGObjectAt(window, x + 2 * RADIUS, y);
    if (object != NULL)
    {
        return object;
    }

    // check for collision at ball's bottom-left corner
    object = getGObjectAt(window, x, y + 2 * RADIUS);
    if (object != NULL)
    {
        return object;
    }

    // check for collision at ball's bottom-right corner
    object = getGObjectAt(window, x + 2 * RADIUS, y + 2 * RADIUS);
    if (object != NULL)
    {
        return object;
    }

    // no collision
    return NULL;
}
