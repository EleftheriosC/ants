#include <stdio.h>
#include <platform.h>

typedef struct
{
    uint x, y;
} Location;

typedef struct
{
    uint id;
    Location location;
    uint current_food;
} Ant;

typedef enum {East, South} Direction;

Location calculate_east_location(Location location)
{
    Location east_location = {(location.x + 1) % 4, location.y};
    return east_location;
}

Location calculate_south_location(Location location)
{
    Location south_location = {location.x, (location.y + 1) % 3};
    return south_location;
}

Location move_to_most_fertile_location(uint world[][4], Direction direction, Ant ant)
{
    if (direction == East)
    {
        return calculate_east_location(ant.location);
    }
    else
    {
        return calculate_south_location(ant.location);
    }
}

uint get_fertility(uint world[][4], Location location)
{
    return world[location.y][location.x];
}

Direction get_most_fertile_move(uint world[][4], Location location)
{
    Direction direction;
    uint fertility_south = get_fertility(world,calculate_south_location(location));
    uint fertility_east = get_fertility(world, calculate_east_location(location));
    if (fertility_east > fertility_south)
    {
        direction = East;
    }
    else
    {
        direction = South;
    }
    return direction;
}

uint calculate_ant_current_food(Ant ant, uint world[][4])
{
    uint current_location_fertility = get_fertility(world, ant.location);
    ant.current_food = ant.current_food + current_location_fertility;
    return ant.current_food;
}

Ant create_ant (uint id, uint world[][4], Location location)
{
    Ant ant;
    ant.id = id;
    ant.location = location;
    ant.current_food = get_fertility(world, location);
    return ant;
}

void print_ant(Ant ant)
{
    printf("Ant %d's position: [%d, %d] and current food: %d\n", ant.id, ant.location.x, ant.location.y, ant.current_food);
}

Ant move_ant(Ant ant, Direction direction, uint world[][4])
{
    ant.location = move_to_most_fertile_location(world, direction, ant);
    ant.current_food = calculate_ant_current_food(ant, world);
    return ant;
}

void run_ant (int index)
{
    Direction direction;
    Location least_fertile_locations[4] = { { 1, 0 }, { 2, 1 }, { 2, 0 }, { 0, 1 } };
    uint ant_world[3][4] =
    {
            { 10, 0, 1, 7 },
            { 2, 10, 0, 3 },
            { 6, 8, 7, 6 }
    };
    Ant ant = create_ant(index, ant_world, least_fertile_locations[index]);
    for (int i = 0; i < 2; i++) {
        direction = get_most_fertile_move(ant_world, ant.location);
        ant = move_ant(ant, direction, ant_world);
        print_ant(ant);
    }
}

int main(void)
{
    uint world[3][4] =
    {
            { 10, 0, 1, 7 },
            { 2, 10, 0, 3 },
            { 6, 8, 7, 6 }
    };
    Location queen_ant_location = {1, 1};
    Location worker_locations[2] = {{0, 1}, {1, 0}};


    return 0;
}
