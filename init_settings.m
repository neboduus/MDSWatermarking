%ATTACK SETTINGS
attack_config = AttackConfig; %Create an instance
attack_config.lazy = false; %If true then stop attacking a soon as a succesful attack is delivered
attack_config.stubborn_until = 15; %Set an upper limit to the times a round can repeat itself
attack_config.filters = [ %List of filters with params to be applied
%FilterConfiguration().setFilter(FilterEnum.AWGN).setNoisepower(.001).setSeed(100)
FilterConfiguration().setFilter(FilterEnum.BLURRING).setNoisepower(0.7175)
FilterConfiguration().setFilter(FilterEnum.JPEG).setQualityfactor(95)
%FilterConfiguration().setFilter(FilterEnum.SHARPENING).setNoisepower(0.25).setNradius(1)
%FilterConfiguration().setFilter(FilterEnum.JPEG).setQualityfactor(96)
%FilterConfiguration().setFilter(FilterEnum.EQUALIZATION).setNoisepower(10)
%FilterConfiguration().setFilter(FilterEnum.RESIZING).setNoisepower(0.80)
%FilterConfiguration().setFilter(FilterEnum.MEDIAN).setNa(20).setNb(40)
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
detect = str2func(strcat('detection_',agroupname)); %search by agroupname
export = @exportcsv;
