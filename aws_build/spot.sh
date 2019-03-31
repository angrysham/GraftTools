#!/bin/bash

case $1 in

  create)
	create_spot
;;

  terminate)
 	terminate_spot	
;;

*)
  echo "Usage $0 [32mcreate[0m|[31mterminate[0m"

esac

create_spot(){

cat << EOF > spot_fleet.json
{
  "IamFleetRole": "arn:aws:iam::442476588438:role/aws-service-role/spotfleet.amazonaws.com/AWSServiceRoleForEC2SpotFleet",
  "AllocationStrategy": "lowestPrice",
  "TargetCapacity": 1,
  "SpotPrice": "0.333",
  "ValidFrom": "2019-02-21T22:01:17Z",
  "ValidUntil": "2020-03-30T22:01:17Z",
  "TerminateInstancesWithExpiration": true,
  "LaunchSpecifications": [
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "m4.xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "SpotPrice": "0.2",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "t3.xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "SpotPrice": "0.167",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "m3.xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "SpotPrice": "0.266",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "r3.xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "SpotPrice": "0.333",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "t3.2xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "WeightedCapacity": 2,
      "SpotPrice": "0.167",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "r4.xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "SpotPrice": "0.266",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "t2.2xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "WeightedCapacity": 2,
      "SpotPrice": "0.1856",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    },
    {
      "ImageId": "ami-06a556b364d73800b",
      "InstanceType": "m4.2xlarge",
      "SubnetId": "subnet-b0b7dffb, subnet-168b981a, subnet-98fe88fc, subnet-ae0c8291, subnet-3bb51914, subnet-a2b312ff",
      "KeyName": "ELK_Prod",
      "WeightedCapacity": 2,
      "SpotPrice": "0.2",
      "BlockDeviceMappings": [
        {
          "DeviceName": "/dev/sda1",
          "Ebs": {
            "DeleteOnTermination": true,
            "VolumeType": "gp2",
            "VolumeSize": 20,
            "SnapshotId": "snap-0ed4f729205f4b920"
          }
        }
      ],
      "SecurityGroups": [
        {
          "GroupId": "sg-0bf1c2a14368f164b"
        }
      ]
    }
  ],
  "Type": "request",
  "InstancePoolsToUseCount": 11
}
EOF

aws ec2 request-spot-fleet --spot-fleet-request-config file://spot_fleet.json | tee > request.json

}

terminate_stop(){
aws ec2 describe-spot-fleet-requests |grep active |awk -F ' ' '{print $4}'| xargs -I '$' aws ec2 cancel-spot-fleet-requests --spot-fleet-request-ids '$' --terminate-instances
}
