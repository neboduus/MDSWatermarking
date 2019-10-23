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
