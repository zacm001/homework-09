%Homework_09

% 00 Connect to ROS (use your own masterhost IP address)
    clc
    clear
    rosshutdown;
    masterhostIP = "192.168.2.128";
    rosinit(masterhostIP)

% 01 Go Home
    disp('Going home...');
    goHome('qr');    % moves robot arm to a qr or qz start config
    disp('Resetting the world...');
    resetWorld;      % reset models through a gazebo service

% Getting can
%cans are indexed as numbers 24 to 29
 %  1   'ground_plane'}
 %  2   'table1'      }
 %  3   'table2'      }
 %  4   'unit_box'    }
 %  5   'BlueBin'     }
 %  6   'GreenBin'    }
 %  7   'robot'       }
 %  8   'wcase'       }
 %  9   'box1'        }
 %  10  'box2'        }
 %  11  'scale1'      }
 %  12  'pouch1'      }
 %  13  'pouch2'      }
 %  14  'pouch3'      }
 %  15  'pouch4'      }
 %  16  'pouch5'      }
 %  17  'pouch6'      }
 %  18  'pouch7'      }
 %  19  'pouch8'      }
 %  20  'gCan1'       }
 %  21  'gCan2'       }
 %  22  'gCan3'       }
 %  23  'gCan4'       }
 %  24  'rCan1'       }
 %  25  'rCan2'       }
 %  26  'rCan3'       }
 %  27  'yCan1'       }
 %  28  'yCan2'       }
 %  29  'yCan3'       }
 %  30  'yCan4'       }
 %  31  'rBottle1'    }
 %  32  'rBottle2'    }
 %  33  'bBottle1'    }
 %  34  'bBottle2'    }
 %  35  'bBottle3'    }
 %  36  'yBottle1'    }
 %  37 - 'yBottle2'    }
 %  38 - 'yBottle3'    }
 %  39 - yBottle4'

for i = 15
    grabcan([i])
end 

disp('Done')