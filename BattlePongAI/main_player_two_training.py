import asyncio

import show_image as si
from ActionSpace import ActionSpace
from Gym import Gym


async def main():
    print("Hello World!")
    gym = Gym("localhost", 9080, "player_one")

    recieved_values = await gym.connect_player()
    data = recieved_values[0]
    print('main data', data)
    while (True):
        player_two_y = data['observation']['PlayerTwo']['Y']
        ball_y = data['observation']['ball']['position']['Y']

        recieved_values = await gym.step(ActionSpace.training)
        data = recieved_values[0]
        try:
            # Test show Image
            si.show_image("L", data['info']['screenshot']['width'],
                          data['info']['screenshot']['height'],
                          data['info']['screenshot']['image'])
        except Exception as e:
            print("failed showing image: " + str(e))
        print('main data', data)

    print('done')


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
