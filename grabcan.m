function pickup_status = grabcan(ModelNumber)

        disp('Getting goal...')

        % Getting Pose 
        models = getModels;                         % Extract gazebo model list
        model_name = models.ModelNames{ModelNumber};         % rCan3=26, yCan1=27,rBottle2=32...%model_name = models.ModelNames{i}  
    
        fprintf('Picking up model: %s \n',model_name);
        [mat_R_T_G, mat_R_T_M] = get_robot_object_pose_wrt_base_link(model_name);

        % Calling Manuvering Cans
        Manuver_Cans(mat_R_T_M, mat_R_T_G)