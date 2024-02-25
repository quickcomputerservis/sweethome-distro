const dgram = require('dgram');
const mqtt = require('mqtt');

// UDP server setup
const udpServer = dgram.createSocket('udp4');
const udpPort = 12345; // Choose your desired UDP port

udpServer.on('error', (err) => {
  console.log(`UDP server error:\n${err.stack}`);
  udpServer.close();
});

udpServer.on('message', (msg, rinfo) => {
  console.log(`Received UDP message from ${rinfo.address}:${rinfo.port}: ${msg}`);

  // MQTT broker setup
  const mqttBrokerUrl = 'mqtt://mqtt.example.com'; // Replace with your MQTT broker URL
  const mqttClient = mqtt.connect(mqttBrokerUrl);

  mqttClient.on('connect', () => {
    console.log('Connected to MQTT broker');

    // Forward UDP message to MQTT
    const topic = 'udp_commands';
    mqttClient.publish(topic, msg.toString(), (err) => {
      if (err) {
        console.error('Error publishing to MQTT:', err);
      } else {
        console.log(`Published message to MQTT topic ${topic}`);
        mqttClient.end();
      }
    });
  });

  mqttClient.on('error', (err) => {
    console.error('Error connecting to MQTT broker:', err);
  });
});

udpServer.on('listening', () => {
  const address = udpServer.address();
  console.log(`UDP server listening on ${address.address}:${address.port}`);
});

udpServer.bind(udpPort);