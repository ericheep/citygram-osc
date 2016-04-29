// example_recieve.ck
// a quick example that shows how to recieve
// OSC data from the CityGram python script

// osc setup 
OscIn oin;
OscMsg msg;

12345 => oin.port;
oin.listenAll();

int num_rsds;
float mean_rms, mean_centroid;

while (true) {
    oin => now;
    while (oin.recv(msg)) {
        if (msg.address =="/numRsds") {
            msg.getInt(0) => num_rsds;
            <<< "NumRDSs", num_rsds >>>;
        }
        if (msg.address =="/allRms") {
            string all_rms;
            for (int i; i < num_rsds; i++) {
                msg.getFloat(i) + " " +=> all_rms; 
            }
            //<<< "RMS:", all_rms, "" >>>;
        }
        if (msg.address =="/allCentroid") {
            string all_centroid;
            for (int i; i < num_rsds; i++) {
                msg.getFloat(i) + " " +=> all_centroid; 
            }
            //<<< "Centroids:", all_centroid, "" >>>;
        }
        if (msg.address == "/meanRms") {
            <<< "Overall mean RMS:", msg.getFloat(0) >>>;
        }
        if (msg.address == "/meanCentroid") {
            <<< "Overall mean Centroid:", msg.getFloat(0) >>>;
        }
    }
} 
