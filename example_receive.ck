// example_recieve.ck
// a quick example that shows how to recieve
// OSC data from the CityGram python script

// osc setup 
OscIn oin;
OscMsg msg;

12345 => oin.port;
oin.listenAll();

while (true) {
    oin => now;
    while (oin.recv(msg)) {
        if (msg.address == "/rms") {
            <<< msg.getFloat(0), msg.getFloat(1) >>>;
        }
        if (msg.address == "/centroid") {
            <<< msg.getFloat(0), msg.getFloat(1) >>>;
        }
    }
} 
