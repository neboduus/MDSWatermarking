function [attack_log] = run_attack(agroupname, I_name, wI_name)
  %SETTINGS
  groupname = 'unemployed'; %Our group name
  do_export = 1; %Enable/disable log export
  %PATHS
  addpath('img'); %This path contains all images
  addpath('detection'); %This path contains the detection function to run
  addpath('export'); %This path contains the export function and csv reports
  %FUNCTIONS
  detect = @detection_groupB;
  export = @exportcsv;

  fprintf('>ATTACK image %s\n',I_name);
  attack_outcome = 0; %Holds the outcome of the current attack
  attack_WPSNR = 100; %Holds the current WPSNR
  attack_log = {}; %Holds the attack log
  minWPSNR = 35; %Minimum WPSNR accepted to break detection

  aI_name = strrep(wI_name,'img/',strcat('img/',groupname,'_')); %Name of the attacked image
  imwrite(imread(wI_name), aI_name); %Copy original watermarked image to attack

  while attack_outcome == 0 && attack_WPSNR>=minWPSNR
    %ATTACK CODE STARTS HERE
    filter = FilterEnum.SHARPENING; %filter to apply
    aI_name = run_filter(aI_name, filter); %Apply filter
    attack_log{end+1} = strcat(filter.name, ','); %Log the attack
    %ATTACK CODE ENDS HERE

    %DETECTION CALL STARTS HERE
    [d_outcome, d_WPSNR] = detect(I_name, wI_name, aI_name);
    %The attack is succesful if d_outcome is 0 and d_WPSNR >= 35
    attack_outcome = d_outcome == 0 && d_WPSNR >= minWPSNR;
    attack_WPSNR = d_WPSNR;
    %DETECTION CALL ENDS HERE
  end

  %Failed attack, return empty log
  if attack_outcome == 0
    attack_log = [];
    %If export is enabled, save the csv with the logged attacks
  elseif do_export == 1
    export(aI_name, agroupname, attack_WPSNR, attack_log, groupname);
  end

end
