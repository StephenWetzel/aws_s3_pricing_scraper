Quick and dirty Ruby script to pull down AWS S3 pricing data from their public APIs and store it in CSV files.

This will hit the same endpoints that [their S3 pricing page](https://aws.amazon.com/s3/pricing/) hits, and create one CSV file for each pricing tier.  Each file will have one row per region, and one column per type of charge.

I'm using their public APIs because it was easy and didn't require authentication.  I'm sure they will change their API at some point, and then this will break.

I wrote this on Ruby 2.7, but it's pretty simple and should run on other versions.  There are no dependencies, so if you have ruby installed you can just download the main .rb file and run.  This is example output.

```
> ruby ./aws_s3_pricing_scraper.rb
https://b0.p.awsstatic.com/locations/1.0/aws/current/locations.json
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-standard.json
Exporting data for s3-standard
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-intelligent-tiering.json
Exporting data for s3-intelligent-tiering
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-standard-infrequent.json
Exporting data for s3-standard-infrequent
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-glacier-instantretrieval.json
Exporting data for s3-glacier-instantretrieval
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-glacier-flexibleretrieval.json
Exporting data for s3-glacier-flexibleretrieval
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3glacierdeeparchive/USD/current/s3glacierdeeparchive.json
Exporting data for s3glacierdeeparchive
https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-onezone-infrequent.json
Exporting data for s3-onezone-infrequent
Done
>
> ls -lahgo
total 76K
drwxr-xr-x 1  922 Sep 11 02:33 .
drwxr-xr-x 1  490 Sep 10 20:17 ..
-rw-r--r-- 1 9.1K Sep 11 02:33 aws_s3_cost_s3glacierdeeparchive_2024-09-11T02_33_23.csv
-rw-r--r-- 1 7.2K Sep 11 02:33 aws_s3_cost_s3-glacier-flexibleretrieval_2024-09-11T02_33_23.csv
-rw-r--r-- 1 4.3K Sep 11 02:33 aws_s3_cost_s3-glacier-instantretrieval_2024-09-11T02_33_23.csv
-rw-r--r-- 1 7.9K Sep 11 02:33 aws_s3_cost_s3-intelligent-tiering_2024-09-11T02_33_23.csv
-rw-r--r-- 1 4.3K Sep 11 02:33 aws_s3_cost_s3-onezone-infrequent_2024-09-11T02_33_24.csv
-rw-r--r-- 1 4.2K Sep 11 02:33 aws_s3_cost_s3-standard_2024-09-11T02_33_23.csv
-rw-r--r-- 1 4.3K Sep 11 02:33 aws_s3_cost_s3-standard-infrequent_2024-09-11T02_33_23.csv
-rw-r--r-- 1 3.0K Sep 11 02:24 aws_s3_pricing_scraper.rb
drwxr-xr-x 1  182 Sep 11 02:33 .git
-rw-r--r-- 1  524 May  4 16:43 .gitignore
-rw-r--r-- 1 1.1K Sep 11 02:33 LICENSE
-rw-r--r-- 1  633 Jan 19  2023 .rubocop.yml
```

I decided to include example outputs in the outputs folder.  So you can view the data as of the last time I ran this [here](https://github.com/StephenWetzel/aws_s3_pricing_scraper/blob/main/outputs/aws_s3_cost_s3-standard_2024-09-25T20_02_34.csv).  Below is the csv for the standard pricing tier.

|region_name              |region_code   |Standard Storage First 50 TB per GB Mo|Standard Storage Next 450 TB per GB Mo|Standard Storage Over 500 TB per GB Mo|Data Returned by S3 Select in Standard per GB|Data Scanned by S3 Select in Standard per GB|GET and all other requests per Requests|PUT COPY/POST or LIST requests per Requests|
|-------------------------|--------------|--------------------------------------|--------------------------------------|--------------------------------------|---------------------------------------------|--------------------------------------------|---------------------------------------|-------------------------------------------|
|US West (Oregon)         |us-west-2     |0.0230000000                          |0.0220000000                          |0.0210000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000050000                               |
|US West (N. California)  |us-west-1     |0.0260000000                          |0.0250000000                          |0.0240000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|US East (Ohio)           |us-east-2     |0.0230000000                          |0.0220000000                          |0.0210000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000050000                               |
|US East (N. Virginia)    |us-east-1     |0.0230000000                          |0.0220000000                          |0.0210000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000050000                               |
|South America (Sao Paulo)|sa-east-1     |0.0405000000                          |0.0390000000                          |0.0370000000                          |0.0014000000                                 |0.0040000000                                |0.0000005600                           |0.0000070000                               |
|Middle East (UAE)        |me-central-1  |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|Middle East (Bahrain)    |me-south-1    |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|Israel (Tel Aviv)        |il-central-1  |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|EU (Zurich)              |eu-central-2  |0.0269500000                          |0.0258500000                          |0.0247500000                          |0.0008000000                                 |0.0022500000                                |0.0000004300                           |0.0000054000                               |
|EU (Stockholm)           |eu-north-1    |0.0230000000                          |0.0220000000                          |0.0210000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000050000                               |
|EU (Spain)               |eu-south-2    |0.0230000000                          |0.0220000000                          |0.0210000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000053000                               |
|EU (Paris)               |eu-west-3     |0.0240000000                          |0.0230000000                          |0.0220000000                          |0.0008000000                                 |0.0022500000                                |0.0000004200                           |0.0000053000                               |
|EU (Milan)               |eu-south-1    |0.0240000000                          |0.0230000000                          |0.0220000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000053000                               |
|EU (London)              |eu-west-2     |0.0240000000                          |0.0230000000                          |0.0220000000                          |0.0008000000                                 |0.0022500000                                |0.0000004200                           |0.0000053000                               |
|EU (Ireland)             |eu-west-1     |0.0230000000                          |0.0220000000                          |0.0210000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000050000                               |
|EU (Frankfurt)           |eu-central-1  |0.0245000000                          |0.0235000000                          |0.0225000000                          |0.0008000000                                 |0.0022500000                                |0.0000004300                           |0.0000054000                               |
|Canada West (Calgary)    |ca-west-1     |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|Canada (Central)         |ca-central-1  |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|Asia Pacific (Tokyo)     |ap-northeast-1|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000003700                           |0.0000047000                               |
|Asia Pacific (Sydney)    |ap-southeast-2|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|Asia Pacific (Singapore) |ap-southeast-1|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0009000000                                 |0.0025000000                                |0.0000004000                           |0.0000050000                               |
|Asia Pacific (Seoul)     |ap-northeast-2|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000003500                           |0.0000045000                               |
|Asia Pacific (Osaka)     |ap-northeast-3|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000003700                           |0.0000047000                               |
|Asia Pacific (Mumbai)    |ap-south-1    |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0009000000                                 |0.0025000000                                |0.0000004000                           |0.0000050000                               |
|Asia Pacific (Melbourne) |ap-southeast-4|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0008000000                                 |0.0022500000                                |0.0000004400                           |0.0000055000                               |
|Asia Pacific (Malaysia)  |ap-southeast-5|0.0225000000                          |0.0216000000                          |0.0207000000                          |0.0008100000                                 |0.0022500000                                |0.0000003600                           |0.0000045000                               |
|Asia Pacific (Jakarta)   |ap-southeast-3|0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0009000000                                 |0.0025000000                                |0.0000004000                           |0.0000050000                               |
|Asia Pacific (Hyderabad) |ap-south-2    |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0009000000                                 |0.0025000000                                |0.0000004000                           |0.0000050000                               |
|Asia Pacific (Hong Kong) |ap-east-1     |0.0250000000                          |0.0240000000                          |0.0230000000                          |0.0009000000                                 |0.0025000000                                |0.0000004000                           |0.0000050000                               |
|Africa (Cape Town)       |af-south-1    |0.0274000000                          |0.0262000000                          |0.0250000000                          |0.0007000000                                 |0.0020000000                                |0.0000004000                           |0.0000060000                               |
|AWS GovCloud (US-East)   |us-gov-east-1 |0.0390000000                          |0.0370000000                          |0.0355000000                          |0.0010000000                                 |0.0030000000                                |0.0000004000                           |0.0000050000                               |
|AWS GovCloud (US)        |us-gov-west-1 |0.0390000000                          |0.0370000000                          |0.0355000000                          |0.0010000000                                 |0.0030000000                                |0.0000004000                           |0.0000050000                               |
