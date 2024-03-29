function traj_result = moveTo(mat_R_T_M,ops)
    %----------------------------------------------------------------------
    % moveTo 
    % Moves to a desired location either as a single point or a trajectory
    % of waypoints.
    % 
    % 01 Set goal or waypoints as a homogeneous transform
    % 02 Convert to joint angles via IKs
    %
    % Inputs
    % mat_R_T_M [4x4]: object pose wrt to base_link
    % ops (dictionary): contains options like debug, toolFlag, traj_steps, traj_duration, etc
    %
    % Outputs:
    % traj_result (bool): 0 indicates success, other failure.
    %----------------------------------------------------------------------
    %% 1. Local variables
    ur5e = loadrobot("universalUR5e",DataFormat="row");   

    %% 2. Call ctraj.
    disp('Computing matlab waypoints via ctraj...');
    % if nargin == 2
        %mat_traj = ctraj(mat_R_T_G,mat_R_T_M,ops('traj_steps') ); % Currently unstable due to first ik transformation of joints. Just do one point.
    % end
    mat_traj = mat_R_T_M;
    
    %% 3. Convert to joint angles via IKs
    disp('Converting waypoints to joint angles...');
    [mat_joint_traj,rob_joint_names] = convertPoseTraj2JointTraj(ur5e,mat_traj,ops('toolFlag'));

    %% Visualize trajectory
    if ops('debug')
        r = rateControl(1);
        for i = 1:size(mat_joint_traj,1)
            ur5e.show(mat_joint_traj(i,:),FastUpdate=true,PreservePlot=false);
            r.waitfor;
        end
    end
    
    %% 4. Create action client, message, populate ROS trajectory goal and send
    % Instantiate the 
    pick_traj_act_client = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                                           'control_msgs/FollowJointTrajectory', ...
                                           'DataFormat', 'struct');
    
    % Create action goal message from client
    traj_goal = rosmessage(pick_traj_act_client); 
    
    % Convert to trajectory_msgs/FollowJointTrajectory
    disp('Converting to JointTrajectory format...');
    traj_goal = convert2ROSPointVec(mat_joint_traj,rob_joint_names,ops('traj_steps'),ops('traj_duration'),traj_goal); % Consider passing in ops directly
    
    % Finally send ros trajectory with traj_steps
    disp('Sending traj to action server...')
    if waitForServer(pick_traj_act_client)
        disp('Connected to action server. Sending goal...')
        [traj_result,state,status] = sendGoalAndWait(pick_traj_act_client,traj_goal);
    else
        % Re-attempt
        disp('First try failed... Trying again...');
        [traj_result,state,status] = sendGoalAndWait(pick_traj_act_client,traj_goal);
    end 

    traj_result = traj_result.ErrorCode;

    % If you want to cancel the goal, run this command
    %cancelGoal(pick_traj_act_client);
end