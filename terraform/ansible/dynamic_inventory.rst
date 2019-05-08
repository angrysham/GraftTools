Inventory Script Example: AWS EC2
=================================

If you use Amazon Web Services EC2, maintaining an inventory file might not be the best approach, because hosts may come and go over time, be managed by external applications, or you might even be using AWS autoscaling. For this reason, you can use the `EC2 external inventory  <https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py>`_ script.

You can use this script in one of two ways. The easiest is to use Ansible's ``-i`` command line option and specify the path to the script after
marking it executable::

    ansible -i ec2.py -u ubuntu us-east-1d -m ping

The second option is to copy the script to `/etc/ansible/hosts` and `chmod +x` it. You will also need to copy the `ec2.ini  <https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini>`_ file to `/etc/ansible/ec2.ini`. Then you can run ansible as you would normally.

To successfully make an API call to AWS, you will need to configure Boto (the Python interface to AWS). There are a `variety of methods <http://docs.pythonboto.org/en/latest/boto_config_tut.html>`_ available, but the simplest is just to export two environment variables::

    export AWS_ACCESS_KEY_ID='AK123'
    export AWS_SECRET_ACCESS_KEY='abc123'

You can test the script by itself to make sure your config is correct::

    cd contrib/inventory
    ./ec2.py --list

After a few moments, you should see your entire EC2 inventory across all regions in JSON.

If you use Boto profiles to manage multiple AWS accounts, you can pass ``--profile PROFILE`` name to the ``ec2.py`` script. An example profile might be::

    [profile dev]
    aws_access_key_id = <dev access key>
    aws_secret_access_key = <dev secret key>

    [profile prod]
    aws_access_key_id = <prod access key>
    aws_secret_access_key = <prod secret key>

You can then run ``ec2.py --profile prod`` to get the inventory for the prod account, although this option is not supported by ``ansible-playbook``.
You can also use the ``AWS_PROFILE`` variable - for example: ``AWS_PROFILE=prod ansible-playbook -i ec2.py myplaybook.yml``

Since each region requires its own API call, if you are only using a small set of regions, you can edit the ``ec2.ini`` file and comment out the regions you are not using.

There are other config options in ``ec2.ini``, including cache control and destination variables. By default, the ``ec2.ini`` file is configured for **all Amazon cloud services**, but you can comment out any features that aren't applicable. For example, if you don't have ``RDS`` or ``elasticache``, you can set them to ``False`` ::

    [ec2]
    ...

    # To exclude RDS instances from the inventory, uncomment and set to False.
    rds = False

    # To exclude ElastiCache instances from the inventory, uncomment and set to False.
    elasticache = False
    ...

At their heart, inventory files are simply a mapping from some name to a destination address. The default ``ec2.ini`` settings are configured for running Ansible from outside EC2 (from your laptop for example) -- and this is not the most efficient way to manage EC2.

If you are running Ansible from within EC2, internal DNS names and IP addresses may make more sense than public DNS names. In this case, you can modify the ``destination_variable`` in ``ec2.ini`` to be the private DNS name of an instance. This is particularly important when running Ansible within a private subnet inside a VPC, where the only way to access an instance is via its private IP address. For VPC instances, `vpc_destination_variable` in ``ec2.ini`` provides a means of using which ever `boto.ec2.instance variable <http://docs.pythonboto.org/en/latest/ref/ec2.html#module-boto.ec2.instance>`_ makes the most sense for your use case.

The EC2 external inventory provides mappings to instances from several groups:

Global
  All instances are in group ``ec2``.

Instance ID
  These are groups of one since instance IDs are unique.
  e.g.
  ``i-00112233``
  ``i-a1b1c1d1``

Region
  A group of all instances in an AWS region.
  e.g.
  ``us-east-1``
  ``us-west-2``

Availability Zone
  A group of all instances in an availability zone.
  e.g.
  ``us-east-1a``
  ``us-east-1b``

Security Group
  Instances belong to one or more security groups. A group is created for each security group, with all characters except alphanumerics, converted to underscores (_). Each group is prefixed by ``security_group_``. Currently, dashes (-) are also converted to underscores (_). You can change using the replace_dash_in_groups setting in ec2.ini (this has changed across several versions so check the ec2.ini for details).
  e.g.
  ``security_group_default``
  ``security_group_webservers``
  ``security_group_Pete_s_Fancy_Group``

Tags
  Each instance can have a variety of key/value pairs associated with it called Tags. The most common tag key is 'Name', though anything is possible. Each key/value pair is its own group of instances, again with special characters converted to underscores, in the format ``tag_KEY_VALUE``
  e.g.
  ``tag_Name_Web`` can be used as is
  ``tag_Name_redis-master-001`` becomes ``tag_Name_redis_master_001``
  ``tag_aws_cloudformation_logical-id_WebServerGroup`` becomes ``tag_aws_cloudformation_logical_id_WebServerGroup``

When the Ansible is interacting with a specific server, the EC2 inventory script is called again with the ``--host HOST`` option. This looks up the HOST in the index cache to get the instance ID, and then makes an API call to AWS to get information about that specific instance. It then makes information about that instance available as variables to your playbooks. Each variable is prefixed by ``ec2_``. Here are some of the variables available:

- ec2_architecture
- ec2_description
- ec2_dns_name
- ec2_id
- ec2_image_id
- ec2_instance_type
- ec2_ip_address
- ec2_kernel
- ec2_key_name
- ec2_launch_time
- ec2_monitored
- ec2_ownerId
- ec2_placement
- ec2_platform
- ec2_previous_state
- ec2_private_dns_name
- ec2_private_ip_address
- ec2_public_dns_name
- ec2_ramdisk
- ec2_region
- ec2_root_device_name
- ec2_root_device_type
- ec2_security_group_ids
- ec2_security_group_names
- ec2_spot_instance_request_id
- ec2_state
- ec2_state_code
- ec2_state_reason
- ec2_status
- ec2_subnet_id
- ec2_tag_Name
- ec2_tenancy
- ec2_virtualization_type
- ec2_vpc_id

Both ``ec2_security_group_ids`` and ``ec2_security_group_names`` are comma-separated lists of all security groups. Each EC2 tag is a variable in the format ``ec2_tag_KEY``.

To see the complete list of variables available for an instance, run the script by itself::

    cd contrib/inventory
    ./ec2.py --host ec2-12-12-12-12.compute-1.amazonaws.com

Note that the AWS inventory script will cache results to avoid repeated API calls, and this cache setting is configurable in ec2.ini.  To
explicitly clear the cache, you can run the ec2.py script with the ``--refresh-cache`` parameter::

    ./ec2.py --refresh-cache
