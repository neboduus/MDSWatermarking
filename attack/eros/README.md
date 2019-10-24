# Attack

To run the attack call the following function
```
run_attack("groupB", "imageName.bmp")
```
* **run_attack.m** holds the main function
* **init_settings.m** holds the configuration settings
* **FilterConfiguration.m** holds the class for filter's configuration and execution
* **FilterEnum.m** holds the enumeration class for the filters
* **AttackConfig.m** holds the class for the attack configuration (filters and settings)

## Folders

* **detection** - Any detection function goes here
  * *detection_{groupname}.p* holds the detection function of *groupname*
* **export** - Report logic and data
  * *exportcsv.m* holds the function called to produce the attack report
  * *unemployed_{groupname}_{imageName}.csv* is the report of the attack on *imageName* watermarked by *groupname*
* **img** - Any image goes here
  * *nowatermark* holds the original images provided for the competition
  * *{groupname}_{imageName}.bmp* is *imageName* watermarked by *groupname*
  * *unemployed_{groupname}_{imageName}.{bmp|jpg}* is *imageName* watermarked by *groupname* and successfully attacked by us
