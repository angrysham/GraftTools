#!/bin/bash 


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

terminate_spot(){
aws ec2 describe-spot-fleet-requests --output=text |grep active |awk -F ' ' '{print $3}'| xargs -I '$' aws ec2 cancel-spot-fleet-requests --spot-fleet-request-ids '$' --terminate-instances
}

if [ -z  "$AWS_ACCESS_KEY_ID" ]; then
       	echo -e "Envoronment AWS_ACCESS_KEY_ID hasn't been defined. Please export it to continue..." 
	echo -e "\nFollowing Environment variables are mandatory and should be defined: \n\t AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY \n\t export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX \n\t export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYY"
	exit 1 
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
      	echo -e "Envoronment AWS_SECRET_ACCESS_KEY hasn't been defined. Please export it to continue..." 
       	exit 1
fi

case $1 in

  create)
	create_spot
	;;

  status)
	  echo "You have active: $(aws ec2 describe-spot-fleet-requests --output=text |grep active |wc -l) spot requests"
	;;

  terminate)
 	terminate_spot	
	;;
  
  modify_json)
	SNAP_ID=`aws ec2 describe-images --image-ids $2 --output=text | grep snap | awk -F ' ' '{print $4}'`
        echo ${SNAP_ID}
	sed  's/${AMI_ID}/'$2'/g; s/${SNAPSHOT_ID}/'$SNAP_ID'/g' spot_fleet_template.json > spot_fleet.json
	;;

*)
  echo -e "Usage $0 [32mcreate[0m|[31mterminate[0m| status|  modify_json AMI_ID\n\t create -- create spot request\n\t terminate -- terminate active spot request"
esac

