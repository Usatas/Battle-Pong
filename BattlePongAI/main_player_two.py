import asyncio

from ActionSpace import ActionSpace
from Gym import Gym

async def main():
    print("Hello World!")
    gym = Gym("localhost", 9080, "player_two")

    recieved_values= await gym.connect_player()
    data = recieved_values[0]
    print('main data', data)
    while(True):
        player_two_y=data['observation']['PlayerTwo']['Y']
        ball_y = data['observation']['ball']['position']['Y']
        if (player_two_y <ball_y):
            recieved_values = await gym.step(ActionSpace.down)
            data = recieved_values[0]
            print('main data', data)
        if (player_two_y >ball_y):
            recieved_values = await gym.step(ActionSpace.up)
            data = recieved_values[0]
            print('main data', data)
        if (player_two_y ==ball_y):
            recieved_values = await gym.step(ActionSpace.nothing)
            data = recieved_values[0]
            print('main data', data)

    print('done')

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())

