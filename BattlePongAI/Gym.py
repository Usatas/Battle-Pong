import asyncio
import random
from socket import socket
import json
import websockets

from ActionSpace import ActionSpace
import logging


class Gym:
    host = None
    port = None
    player = None
    families = None
    types = None
    protocols = None
    logger = None
    # Create a TCP/IP socket
    sock = None
    last_recieved_JSON = None
    websocket_server = None

    def __init__(self, host, port, player):
        self.host = host
        self.port = port
        self.player = player
        random.seed()

        self.families = self.get_constants('AF_')
        self.types = self.get_constants('SOCK_')
        self.protocols = self.get_constants('IPPROTO_')

        self.logger = logging.getLogger('websockets')
        self.logger.setLevel(logging.INFO)
        self.logger.addHandler(logging.StreamHandler())
        print('New gym instance IP:%s Port:%s Playername:%S', host, port, player)

    # Call reset function of environment and returns observation
    async def reset(self):
        message = '["'+self.player+'","start_game"]'
        data = []
        print('send_reset:', message)
        await self.send_websocket(message, data)
        print("awaited send_reset")
        #print(data)
        return data

    # Connects the player and returns observation
    async def connect_player(self):
        message = '["'+self.player+'","connect_player"]'
        data = []
        print('connect_player: ', message)
        await self.send_websocket(message, data)
        print("awaited send_connect_player")
        #print(data)
        return data

    # TPC - creates env
    def open(self, server_ip=None, port=None):
        if server_ip is not None:
            self.host = server_ip
        if port is not None:
            self.port = port
        # connect to server
        self.create_socket(self.host, self.port)

    # TCP - closes the env
    def close(self):
        # send close to server
        # close socket
        self.close_socket("Closing environment")
        pass

    # send action to env returns observation, reward, done, info
    # creates JSON object
    async def step(self, action):
        if isinstance(action, ActionSpace):
            # action is part of ActionSpace
            print("go step")
            data = await self.send_action(action)
            #print('step done', data)
            return data
        else:
            print("Action is not a valid Step")

    """ Returns a random action of action space
    """
    def get_sample_action(self):
        item = random.randrange(0, len(ActionSpace))
        return ActionSpace(item)

    # socket_echo_client_easy.py

    def get_constants(self, prefix):
        """Create a dictionary mapping socket module
        constants to their names.
        """
        return {
            getattr(socket, n): n
            for n in dir(socket)
            if n.startswith(prefix)
        }

    def create_socket(self, server_ip=None, port=None):
        if server_ip is not None:
            self.host = server_ip
        if port is not None:
            self.port = port

        # Create a TCP/IP socket
        self.sock = socket.create_connection(self.host, self.port)

        print('Family  :', self.families[self.sock.family])
        print('Type    :', self.types[self.sock.type])
        print('Protocol:', self.protocols[self.sock.proto])

    async def send_action(self, next_action):
        message = '["'+self.player+'","' +self.player+"_"+ next_action.name + '"]'
        data = []
        print('send_action:',message)
        await self.send_websocket(message, data)
        #print("awaited send_action")
        #print(data)
        return data

    async def send_websocket(self, message, data):
        uri = "ws://localhost:9080"
        async with websockets.connect(uri) as websocket:
            await websocket.send(message)
            # print(f"> {name}")
            recieved_values = await websocket.recv()
            data.append(json.loads(recieved_values))
            #print(f"< {data}")
            #print(data)

    async def connect_to_trainer(self):
        self.websocket_server = websockets.serve(self.get_training, "localhost", 8765)


    async def get_training(self):
        recieved_values = await self.websocket_server.recv()
        print(f"<{recieved_values}")
        return json.loads(recieved_values)


    def send_tcp(self, message):
        try:
            # Send data
            # test message
            # message = b'This is the message.  It will be repeated.'
            print('sending {!r}'.format(message))
            self.sock.sendall(message)

            amount_received = 0
            amount_expected = len(message)
            data = None
            while amount_received < amount_expected:
                data = self.sock.recv(16)
                amount_received += len(data)
                #print('received {!r}'.format(data))
            return data

        except Exception as e:
            self.close_socket("closing socket because of exception {}".format(e.args[-1]))

    # TCP - Closing the socket
    def close_socket(self, message):
        print("Closing Socket")
        print("Msg: " + message)
        self.sock.close()
