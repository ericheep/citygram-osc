"""citygram_osc.py
"""

from io import BytesIO
from pythonosc import osc_message_builder
from pythonosc import udp_client

import json
import time
import pycurl
import numpy as np


def multiCurl(rsds, feature, window=1):
    """Sends a cURL to the CityGram server to then be
    turned into an OSC message

    Parameters
    ----------

    rsds : list of strings
        add more rsds as they are put up
    feature : string
        check the CityGram resources to show what features are
        available, CalArts RSDs only give back fd_centroid and
        td_rms
    window : int, default 1
        time in seconds to take instances over, the server
        seems to grab at 20ms increments

    Returns
    -------

    means, stds: tuple of floats
        the mean and standard deviation of instances over the windowed time
    """

    buffer = BytesIO()

    # turns array into a valid curl data field
    rsd_post = ''
    for rsd in rsds:
        rsd_post += '"' + rsd + '",'

    rsd_post = rsd_post[:-1]

    # post fields message
    post = (
        '{"rsd":[' + rsd_post + '],'
        '"windowSize":' + str(window) + ','
        '"feature":"' + feature + '"}')

    # other curl stuff
    c = pycurl.Curl()
    c.setopt(c.URL, 'http://citygram.smusic.nyu.edu/'
             'streamdata/pull_multiRSDs.php')
    c.setopt(c.HTTPHEADER, ['Content-Type: application/json'])
    c.setopt(c.POSTFIELDS, post)
    c.setopt(c.WRITEFUNCTION, buffer.write)
    c.perform()
    c.close()

    # decodes to a readable format
    body = buffer.getvalue().decode('iso-8859-1')
    body = json.loads(body)

    means = []
    stds = []
    rsd_ids = []

    for rsd in range(len(rsds)):
        if 'featurelist' in body['data'][str(rsd)]:
            features = body['data'][str(rsd)]['featurelist']

            val = np.empty(len(features))
            for idx in range(len(features)):
                val[idx] = (features[idx]['val'])

            means.append(np.mean(val))
            stds.append(np.std(val))
            rsd_ids.append(int(body['data'][str(rsd)]['id'].split('calarts')[1]))

    return means, stds, rsd_ids

# add more rsds as they're available
rsds = [
    'rsdcalarts1', 'rsdcalarts2', 'rsdcalarts3', 'rsdcalarts4',
    'rsdcalarts5', 'rsdcalarts6', 'rsdcalarts7', 'rsdcalarts8',
    'rsdcalarts9', 'rsdcalarts10', 'rsdcalarts11', 'rsdcalarts12',
    'rsdcalarts13', 'rsdcalarts14', 'rsdcalarts16', 'rsdcalarts16']


client = udp_client.UDPClient("127.0.0.1", 12345)

# main loop
while True:
    # start message
    ids = osc_message_builder.OscMessageBuilder(address='/ids')
    rms = osc_message_builder.OscMessageBuilder(address='/rms')
    cent = osc_message_builder.OscMessageBuilder(address='/centroid')

    # add args
    rms_vals = multiCurl(rsds, 'td_rms', 1)
    for idx in range(len(rms_vals[0])):
        rms.add_arg(rms_vals[0][idx], arg_type='f')

    #rms.add_arg(np.mean(rms_vals[1]), arg_type='f')

    cent_vals =multiCurl(rsds, 'fd_centroid', 1)
    for idx in range(len(cent_vals[0])):
        cent.add_arg(cent_vals[0][idx], arg_type='f')

    ids.add_arg(len(rms_vals[2]), arg_type='i')

    # build
    ids = ids.build()
    rms = rms.build()
    cent = cent.build()

    # sends number of ids, sleeps for a bit
    client.send(ids)
    time.sleep(0.01)

    # sends the rest
    client.send(rms)
    client.send(cent)

    # one second per loop
    # time.sleep(0.1)
