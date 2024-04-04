%Homework_09

% 00 Connect to ROS (use your own masterhost IP address)
    clc
    clear
    rosshutdown;
    masterhostIP = "192.168.213.128";
    rosinit(masterhostIP)

% 01 Go Home
    disp('Going home...');
    goHome('qr');    % moves robot arm to a qr or qz start config
    disp('Resetting the world...');
    resetWorld;      % reset models through a gazebo service

% 02 rCan3
    % 01 Getting Pose for rCan3
        disp('Getting goal...')
    
        models = getModels;                         % Extract gazebo model list
        model_name = models.ModelNames{27};         % rCan3=26, yCan1=27,rBottle2=32...%model_name = models.ModelNames{i}  
    
        fprintf('Picking up model: %s \n',model_name);
        [mat_R_T_G, mat_R_T_M] = get_robot_object_pose_wrt_base_link(model_name);

    % 04 Pick Model
        % Assign strategy: topdown, direct
        strategy = 'topdown';
        ret = pick(strategy, mat_R_T_M);  % Can have optional starting pose for ctraj like: ret = pick(strategy, mat_R_T_M,mat_R_T_G);
    
    % 05 Place
        if ~ret
            disp('Attempting place...')
            greenBin = [-0.4, -0.45, 0.25, -pi/2, -pi 0];
            place_pose = set_manual_goal(greenBin);
            strategy = 'topdown';
            fprintf('Moving to bin...');
            ret = moveToBin(strategy,mat_R_T_M,place_pose);
        end
        
        % Return to home
        if ~ret
            ret = moveToQ('qr');
        end

disp('Done')