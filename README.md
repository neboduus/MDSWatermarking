# Multimedia Data Security - Watermarking

Watermarking is a technique which can be used to insert information into images in order to prevent for example illegal distribution of private images.
The following work contains an implementation of the technique published in following article: 
>
> -- <cite>Arya, Ranjan & Singh, Shalu & Saharan, Ravi. (2015). A Secure Non-blind Block Based Digital Image Watermarking Technique Using DWT and DCT. 10.1109/ICACCI.2015.7275917. </cite>

Basically we embed a 32x32 binary watermark into a 512x512 gereyscale image. For more details such as Threshold computation, please 
refer to the Rules.pdf file which contains the rules of the challage where this project was used to reach position 8/15.

## Requirements
The code provided was developed and tested on Matlab R2019b.

# Attack
We also provide some functionalities to test this but also others watermarking techniques.

We used this code to participate to a challange where teams had to embed a private watermark in some images. Then the other teams had to "attack" the images
 in order to test how much the watermark was robust. The attack consists in jpeg compression, median filtering, etc. It was also required that after WPSNR(OriginalImg,WatermarkedImage)>=35,
which puts limits on attack brutality.

## Steps

1. Put the original images provided during the competition inside *img/nowatermark*
2. Put the *pcode* of the detection function inside *detection/*
3. Edit *init_settings* to to configure your attack (filters, parameters and general settings)
4. Run the attack by calling the following function
```
run_attack("groupname", "imageName.bmp")
```
5. If any attack was successful in breaking the detection you will find the result of the attack inside *img/* and *export/*
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
