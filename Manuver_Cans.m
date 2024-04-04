function help = Manuver_Cans(mat_R_T_M, mat_R_T_G)
    % Manuver Cans
    

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
    
end