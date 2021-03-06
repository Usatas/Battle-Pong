import asyncio

import show_image as si
from ActionSpace import ActionSpace
from Gym import Gym


async def main():
    print("Hello World!")
    gym = Gym("localhost", 10000, "player_one")
    # data = await gym.step(ActionSpace.UP)
    # print('main data', data)
    recieved_values = await gym.connect_player()
    data = recieved_values[0]
    recieved_values = await gym.reset()
    data = recieved_values[0]
    print('main data', data)
    image_mode = 'RGB'
    try:
        # Test show Image
        si.show_image(image_mode, data['info']['screenshot']['width'], data['info']['screenshot']['height'],
                      data['info']['screenshot']['image'])
    except Exception as e:
        print("failed showing image: " + str(e))
    resetted = True

    while (True):
        if data['done']:
            recieved_values = await gym.reset()
            data = recieved_values[0]
        if resetted:
            resetted = False
        player_one_y = data['observation']['PlayerOne']['Y']
        ball_y = data['observation']['ball']['position']['Y']
        if (player_one_y < ball_y):
            recieved_values = await gym.step(ActionSpace.down)
            data = recieved_values[0]
            print('main data', data)
        if (player_one_y > ball_y):
            recieved_values = await gym.step(ActionSpace.up)
            data = recieved_values[0]
            print('main data', data)
        if (player_one_y == ball_y):
            recieved_values = await gym.step(ActionSpace.nothing)
            data = recieved_values[0]
            print('main data', data)
        try:
            # Test show Image
            si.show_image(image_mode, data['info']['screenshot']['width'],
                          data['info']['screenshot']['height'],
                          data['info']['screenshot']['image'])
        except Exception as e:
            print("failed showing image: " + str(e))

    print('done')


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
