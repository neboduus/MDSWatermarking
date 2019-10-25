%ATTACK SETTINGS
attack_config = AttackConfig; %Create an instance
attack_config.lazy = false; %If true then stop attacking a soon as a succesful attack is delivered
attack_config.filters = [ %List of filters with params to be applied
FilterConfiguration().setFilter(FilterEnum.JPEG).setQualityfactor(95)
FilterConfiguration().setFilter(FilterEnum.BLURRING).setNoisepower(2)
FilterConfiguration().setFilter(FilterEnum.SHARPENING).setNoisepower(1).setNradius(3)
FilterConfiguration().setFilter(FilterEnum.AWGN).setNoisepower(.000001).setSeed(100)
];
mappings = attack_config.mappings;
%GENERAL SETTINGS
groupname = 'unemployed'; %Our group name
do_export = 1; %Enable/disable log export
%PATHS
addpath('img'); %This path contains all images
addpath('detection'); %This path contains the detection function to run
addpath('export'); %This path contains the export function and csv reports
%FUNCTIONS
detect = str2func(strcat('detection_',agroupname));
export = @exportcsv;
