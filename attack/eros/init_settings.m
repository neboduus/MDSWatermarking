%ATTACK SETTINGS
attack_config = AttackConfig; %Create an instance
attack_config.lazy = false; %If true then stop attacking ASA a succesful attack is delivered
attack_config.filters = [ %List of filters with params to be applied
FilterConfiguration(FilterEnum.BLURRING, 2, 0, 0, 0, 0, 0)
FilterConfiguration(FilterEnum.SHARPENING, 3, 0, 0, 0, 0, 1)
FilterConfiguration(FilterEnum.AWGN, .000001, 100, 0, 0, 0, 0)
];
%GENERAL SETTINGS
groupname = 'unemployed'; %Our group name
do_export = 1; %Enable/disable log export
%PATHS
addpath('img'); %This path contains all images
addpath('detection'); %This path contains the detection function to run
addpath('export'); %This path contains the export function and csv reports
%FUNCTIONS
detect = @detection_groupB;
export = @exportcsv;
