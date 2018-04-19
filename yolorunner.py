#!/usr/bin/env python3


import os
import sys
import traceback
sys.path.append('../actionProxy')
from actionproxy import ActionRunner, main, setRunner

import cv2
import base64
import json
import numpy
import time

from darkflow.net.build import TFNet

options = {}


class YoloRunner(ActionRunner):

    def __init__(self):
        ActionRunner.__init__(self, '/action/__main__.py')
    
    def init(self, message):
        df_options = {"metaLoad": "model/yolo.meta", "pbLoad": "model/yolo.pb", "threshold": 0.1}
        options["tfnet"] = TFNet(df_options)
        return True

    def verify(self):
        return True

    def run(self, args, env):
        result = None
        try:
            os.environ = env
            result = self.score(args)
        except Exception as e:
            traceback.print_exc(file=sys.stderr)
            return (502, {'error': 'Action threw an exception: {}'.format(e)})

        if result and isinstance(result, dict):
            return (200, result)
        else:
            return (502, {'error': 'The action did not return a dictionary.'})

    def score(self, params):
        if "warmup" in params:
            time.sleep(10)
            return {"success": "true"}

        image = base64.b64decode(params.get("image"))
    
        imgcv = cv2.imdecode(numpy.asarray(bytearray(image), dtype=numpy.uint8), cv2.IMREAD_COLOR)
        result = options["tfnet"].return_predict(imgcv)

        params["objects"] = [{"voc": r["label"],
                              "score": float(r["confidence"]),
                              "tl_x": float(r["topleft"]["x"]),
                              "tl_y": float(r["topleft"]["y"]),
                              "br_x": float(r["bottomright"]["x"]),
                              "br_y": float(r["bottomright"]["y"])}
                             for r in result]
        del params["image"]
        return params
    

if __name__ == '__main__':
    setRunner(YoloRunner())
    main()
