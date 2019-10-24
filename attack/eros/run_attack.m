function [best_log] = run_attack(agroupname, I_name, wI_name)
  init_settings %load initial settings
  fprintf('>ATTACK image %s\n',I_name);
  I_name=strcat('img/nowatermark/',I_name); %Set image path
  wI_name=strrep(I_name,'nowatermark/',strcat(agroupname,'_')); %Set image path
  minWPSNR = 35; %Minimum WPSNR accepted to break detection
  aI_name = strrep(wI_name,'img/',strcat('img/',groupname,'_')); %Set attacked image path
  bestround = -1; %Holds the id of the best round (succesful attack with highest WPSNR)
  bestWPSNR = -1; %Holds the WPSNR of the best round
  best_log = {}; %Holds the attack log of the best round
  i = 1;
  stop = false;
  while stop == false
    fprintf('Start round %i\n',i);
    attack_outcome = 0; %Holds the outcome of the current attack
    attack_WPSNR = 100; %Holds the current WPSNR
    attack_log = {}; %Reset the attack log
    imwrite(imread(wI_name), aI_name); %Copy original watermarked image to attack
    mapping = mappings(i,:); %Consider the ith attack mapping
    j = 1; %Consider the jth filter
    while j<=size(mapping, 2) && attack_outcome == 0 && attack_WPSNR>=minWPSNR
      %ATTACK CODE STARTS HERE
      filter_config = attack_config.filters(mapping(j));
      run_filter(filter_config, aI_name); %Apply filter
      attack_log{end + 1} = strcat(filter_config.filter.name,' (', filter_config.parameters,');'); %Log the attack
      %ATTACK CODE ENDS HERE

      %DETECTION CALL STARTS HERE
      [d_outcome, d_WPSNR] = detect(I_name, wI_name, aI_name);
      %The attack is succesful if d_outcome is 0 and d_WPSNR >= 35
      attack_outcome = d_outcome == 0 && d_WPSNR >= minWPSNR;
      attack_WPSNR = d_WPSNR;
      %DETECTION CALL ENDS HERE

      if(attack_outcome == 1 && attack_WPSNR>bestWPSNR)
        %Keep track of the best round until now
        bestround = i;
        bestWPSNR = attack_WPSNR;
        best_log = attack_log;
      end

      fprintf('   %s (%s) -> attack_outcome=%d, WPSNR=%f\n',filter_config.filter.name, filter_config.parameters, attack_outcome, attack_WPSNR);
      j = j + 1;
    end
    fprintf('End round %i: attack_outcome=%d, WPSNR=%f\n',i, attack_outcome, attack_WPSNR);

    i = i + 1;
    stop = i > size(mappings, 1); %Stop when all mapping have been executed
    if attack_config.lazy
      %Or when a successful attack has been delivered
      stop = stop || attack_outcome == 1;
    end
  end

  if bestround == -1
    %Failed attack, return empty log
    fprintf('========\nNo successful round');
    best_log = [];
  else
    attacks = sprintf('%s',cell2mat(best_log));
    fprintf('========\nRound %i was the best with WPSNR=%f: %s', bestround, bestWPSNR, attacks);
    if do_export == 1
      export(aI_name, agroupname, attack_WPSNR, best_log, groupname);
    end
  end

  %Failed attack, return empty log
  if attack_outcome == 0
    best_log = [];
    %If export is enabled, save the csv with the logged attacks
  elseif do_export == 1
    export(aI_name, agroupname, bestWPSNR, best_log, groupname);
  end

end
