#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//----------------------------------------------------------------------------

#define CELL_DX     5
#define CELL_DY     3

#define GRID_DX     10 * CELL_DX
#define GRID_DY     10 * CELL_DY

#define CHANNEL_DX  CELL_DX
#define CHANNEL_DY  CELL_DY

#define MAX_PATH    (10 * (GRID_DX + GRID_DY))

//----------------------------------------------------------------------------

struct xy { int x, y; };

//----------------------------------------------------------------------------

enum cell_type
{
    IN   = 0,
    OUT  = 1,
    AND  = 2,
    OR   = 3,
    NOT  = 4,
    BUF  = 5,

    N_CELL_TYPES = 6
};

const char cell_chars [N_CELL_TYPES + 1] = "IOAONB";

const char separator_char = '-';
const char space_char     = '.';
const char in_char        = 'v';
const char out_char       = 'V';
const char wire_char      = '*';

//----------------------------------------------------------------------------

#define MAX_CELL_WIRES  3

struct cell
{
    cell_type type;
    int       wires [MAX_CELL_WIRES];
};

cell cells [] =
{
    { IN  , 1         },
    { IN  , 2         },
    { IN  , 3         },
    { AND , 1 , 2 , 4 },
    { OR  , 3 , 4 , 5 },
    { BUF , 5 , 6 , 7 },
    { NOT , 6 , 8     },
    { OUT , 7         },
    { OUT , 8         },
};

#define N_CELLS    (sizeof (cells) / sizeof (cell))
#define MAX_WIRES  (N_CELLS * MAX_CELL_WIRES)

//----------------------------------------------------------------------------

struct wire
{
    xy from, to;
};

wire wires [MAX_WIRES];

//----------------------------------------------------------------------------

#define MAX_LAYERS  10

char grid [GRID_DX][GRID_DY][MAX_LAYERS];

//----------------------------------------------------------------------------

void error (const char * message)
{
    fprintf (stderr, "*** Error: %s\n", message);
    exit (EXIT_FAILURE);
}

//----------------------------------------------------------------------------

void init_grid ()
{
    memset (grid  , space_char , sizeof ( grid  ));
    memset (wires , 0          , sizeof ( wires ));
}

//----------------------------------------------------------------------------

void dump_grid ()
{
    for (int x = 0; x < GRID_DX ; x ++)
        putchar (separator_char);

    putchar ('\n');

    for (int y = 0; y < GRID_DY; y ++)
    {
        for (int x = 0; x < GRID_DX; x ++)
        {
            int l;

            for (l = 0;
                 l < MAX_LAYERS && grid [x][y][l] != wire_char;
                 l ++ )
            {
            }

            if (l != MAX_LAYERS)
                putchar ('0' + l % 10);
            else
                putchar (grid [x][y][0]);
        }

        putchar ('\n');
    }
}

//----------------------------------------------------------------------------

void wire_out (xy cxy, cell * pc, int w, int dx, int dy)
{
    int * px = & wires [pc -> wires [w]].from.x;
    int * py = & wires [pc -> wires [w]].from.y;

    * px = cxy.x + dx;
    * py = cxy.y + dy;

    for (int l = 0; l < MAX_LAYERS; l ++)
        grid [* px][* py][l] = out_char;
}

//----------------------------------------------------------------------------

void wire_in (xy cxy, cell * pc, int w, int dx, int dy)
{
    int * px = & wires [pc -> wires [w]].to.x;
    int * py = & wires [pc -> wires [w]].to.y;

    * px = cxy.x + dx;
    * py = cxy.y + dy;

    for (int l = 0; l < MAX_LAYERS; l ++)
        grid [* px][* py][l] = in_char;
}

//----------------------------------------------------------------------------

void fill_cell (xy cell_xy, cell * pc)
{
    for (int x = cell_xy.x ; x < cell_xy.x + CELL_DX ; x ++)
    for (int y = cell_xy.y ; y < cell_xy.y + CELL_DY ; y ++)
    {
        for (int l = 0; l < MAX_LAYERS; l ++)
            grid [x][y][l] = cell_chars [pc -> type];
    }

    switch (pc -> type)
    {
        case IN:

            wire_out ( cell_xy, pc, 0,
                CELL_DX / 2, CELL_DY - 1 );

            break;

        case OUT:

            wire_in ( cell_xy, pc, 0,
                CELL_DX / 2, 0 );

            break;

        case AND:
        case OR:

            wire_in ( cell_xy, pc, 0,
                1, 0);

            wire_in ( cell_xy, pc, 1,
                CELL_DX - 2, 0);

            wire_out ( cell_xy, pc, 2,
                CELL_DX / 2, CELL_DY - 1 );

            break;

        case NOT:

            wire_in ( cell_xy, pc, 0,
                CELL_DX / 2, 0);

            wire_out ( cell_xy, pc, 1,
                CELL_DX / 2, CELL_DY - 1 );

            break;

        case BUF:

            wire_in ( cell_xy, pc, 0,
                CELL_DX / 2, 0);

            wire_out ( cell_xy, pc, 1,
                1, CELL_DY - 1 );

            wire_out ( cell_xy, pc, 2,
                CELL_DX - 2, CELL_DY - 1);

            break;

        default:

            error ("bad cell type");
            break;
    }
}

//----------------------------------------------------------------------------

void place_cells ()
{
    xy in_xy  = { 0          , 0                    };
    xy out_xy = { 0          , GRID_DY - CELL_DY    };
    xy std_xy = { CHANNEL_DX , CELL_DY + CHANNEL_DX };

    for (int i = 0; i < N_CELLS; i ++)
    {
        cell * pc = & cells [i];

        switch (pc -> type)
        {
        case IN:

            fill_cell (in_xy, pc);

            in_xy.x += CELL_DX;

            if (in_xy.x > GRID_DX)
                error ("no space for IN cells");

            break;

        case OUT:

            fill_cell (out_xy, pc);

            out_xy.x += CELL_DX;

            if (out_xy.x > GRID_DX)
                error ("no space for OUT cells");

            break;

        case AND:
        case OR:
        case NOT:
        case BUF:

            fill_cell (std_xy, pc);

            switch (rand () % 4)
            {
            default:
            case 0:

                std_xy.x += CELL_DX;
                break;

            case 1:

                std_xy.x += CELL_DX + CHANNEL_DX;
                std_xy.y += CELL_DY;
                break;

            case 2:

                std_xy.x += CELL_DX + CHANNEL_DX;
                std_xy.y += CELL_DY + CHANNEL_DY;
                break;
            }

            if (std_xy.x >= GRID_DX - CELL_DX)
            {
                std_xy.x  = CHANNEL_DX;
                std_xy.y += CELL_DY + CHANNEL_DY;
            }

            if (std_xy.y >= GRID_DY - CELL_DY - CHANNEL_DY - CELL_DY)
                error ("no_space for regular cells");

            break;

        default:

            error ("bad cell");
            break;
        }
    }
}

//----------------------------------------------------------------------------

int dist [GRID_DX][GRID_DY];

const int dist_blocked = INT_MAX;
const int dist_unset   = - 1;

void init_routing_for_a_layer (int l)
{
    for (int x = 0; x < GRID_DX; x ++)
    for (int y = 0; y < GRID_DY; y ++)
    {
        if (grid [x][y][l] == space_char)
            dist [x][y] = dist_unset;
        else
            dist [x][y] = dist_blocked;
    }
}

//----------------------------------------------------------------------------

void dump_distances ()
{
    for (int x = 0; x < GRID_DX ; x ++)
        putchar (separator_char);

    putchar ('\n');

    for (int y = 0; y < GRID_DY; y ++)
    {
        for (int x = 0; x < GRID_DX; x ++)
        {
            if (grid [x][y][0] != space_char)
                putchar (grid [x][y][0]);
            else if (dist [x][y] == dist_blocked)
                putchar (wire_char);
            else if (dist [x][y] == dist_unset)
                putchar (space_char);
            else
                putchar ('0' + dist [x][y] % 10);
        }

        putchar ('\n');
    }
}

//----------------------------------------------------------------------------

bool forward_path (xy from, xy to)
{
    dist [from .x][from .y] = 0;
    dist [to   .x][to   .y] = dist_unset;

    for (int iter = 0; iter < MAX_PATH; iter ++)
    {
        for (int x = 0; x < GRID_DX; x ++)
        for (int y = 0; y < GRID_DY; y ++)
        {
            if (dist [x][y] != dist_unset)
                continue;

            int min = MAX_PATH;

            // This can be written in better way

            if (    x > 0
                 && dist [x - 1][y] != dist_unset
                 && dist [x - 1][y] != dist_blocked
                 && dist [x - 1][y] <  min )
            {
                min = dist [x - 1][y];
            }

            if (    y > 0
                 && dist [x][y - 1] != dist_unset
                 && dist [x][y - 1] != dist_blocked
                 && dist [x][y - 1] <  min )
            {
                min = dist [x][y - 1];
            }

            if (    x < GRID_DX - 1
                 && dist [x + 1][y] != dist_unset
                 && dist [x + 1][y] != dist_blocked
                 && dist [x + 1][y] <  min )
            {
                min = dist [x + 1][y];
            }

            if (    y < GRID_DY - 1
                 && dist [x][y + 1] != dist_unset
                 && dist [x][y + 1] != dist_blocked
                 && dist [x][y + 1] <  min )
            {
                min = dist [x][y + 1];
            }

            if (min != MAX_PATH)
            {
                dist [x][y] = min + 1;

                if (x == to.x && y == to.y)
                    return true;
            }
        }
    }

    return false;
}

//----------------------------------------------------------------------------

void backward_path (xy from, xy to, int l)
{
    int x = from.x;
    int y = from.y;

    for (int iter = 0; iter < MAX_PATH; iter ++)
    {
        int new_dist = dist [x][y] - 1;

        if (x > 0 && dist [x - 1][y] == new_dist)
            x --;
        else if (y > 0 && dist [x][y - 1] == new_dist)
            y --;
        else if (x < GRID_DX - 1 && dist [x + 1][y] == new_dist)
            x ++;
        else if (y < GRID_DY - 1 && dist [x][y + 1] == new_dist)
            y ++;
        else
        {
            printf ("*** Cannot find path %d %d -> %d %d -> %d %d\n",
                from.x, from.y, x, y, to.x, to.y);
            
            dump_distances ();
            error ("internal error");
        }

        // printf ("*** Backward on layer %d: %d %d -> %d %d -> %d %d\n",
        //    l, from.x, from.y, x, y, to.x, to.y);

        if (x == to.x && y == to.y)
            return;
        else
            grid [x][y][l] = wire_char;
    }

    error ("internal error");
}

//----------------------------------------------------------------------------

bool try_to_route_from_to_using_layer (xy from, xy to, int l)
{
    init_routing_for_a_layer (l);

    dist [from.x][from.y] = 0;

    if (forward_path (from, to))
    {
        dump_distances ();
        backward_path (to, from, l);
        return true;
    }

    return false;
}

//----------------------------------------------------------------------------

void route_from_to (xy from, xy to)
{
    // printf ("*** Routing %d %d -> %d %d\n",
    //     from.x, from.y, to.x, to.y);

    for (int l = 0; l < MAX_LAYERS; l ++)
    {
        if (try_to_route_from_to_using_layer (from, to, l))
            return;
    }

    dump_distances ();
    error ("routing failure");
}

//----------------------------------------------------------------------------

void route_wires ()
{
    for (int w = 0; w < MAX_WIRES; w ++)
    {
        if (    (wires [w].from.x == 0 && wires [w].from.y == 0)
             && (wires [w].to.x   == 0 && wires [w].to.y   == 0) )
        {
            continue;
        }

        if (    (wires [w].from.x == 0 && wires [w].from.y == 0)
             || (wires [w].to.x   == 0 && wires [w].to.y   == 0) )
        {
            error ("wire without beginning or an end");
            continue;
        }

        route_from_to
        (
            wires [w].from,
            wires [w].to
        );
    }
}

//----------------------------------------------------------------------------

void dump_wires ()
{
    for (int w = 0; w < MAX_WIRES; w ++)
    {
        if (    (wires [w].from.x == 0 && wires [w].from.y == 0)
             && (wires [w].to.x   == 0 && wires [w].to.y   == 0) )
        {
            continue;
        }

        if (    (wires [w].from.x == 0 && wires [w].from.y == 0)
             || (wires [w].to.x   == 0 && wires [w].to.y   == 0) )
        {
            printf ("??? ");
        }

        printf ("wire %3d : ( %3d %3d ) -> ( %3d %3d )\n",
            w,
            wires [w].from.x , wires [w].from.y,
            wires [w].to.x   , wires [w].to.y );
    }
}

//----------------------------------------------------------------------------

int main ()
{
    printf ("*** Starting up with Place & Route. By Yuri Panchul ***\n");

    init_grid   ();
    place_cells ();
    dump_wires  ();
    route_wires ();
    dump_grid   ();

    return EXIT_SUCCESS;
}
