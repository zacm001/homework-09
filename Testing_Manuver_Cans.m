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

    % 04 Manuvering Model
        % Calling Manuvering Cans
        Manuver_Cans(mat_R_T_M, mat_R_T_G)

disp('Done')