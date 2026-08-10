import boto3

REGION = "us-east-2"

ec2 = boto3.client("ec2", region_name=REGION)

print(f"\nAWS Infrastructure Inventory - {REGION}")
print("=" * 45)

# VPCs
vpcs = ec2.describe_vpcs()["Vpcs"]

print(f"\nVPCs ({len(vpcs)}):")
for vpc in vpcs:
    print(f"  {vpc['VpcId']} | {vpc['CidrBlock']}")

# Subnets
subnets = ec2.describe_subnets()["Subnets"]

print(f"\nSubnets ({len(subnets)}):")
for subnet in subnets:
    print(
        f"  {subnet['SubnetId']} | "
        f"{subnet['CidrBlock']} | "
        f"{subnet['AvailabilityZone']}"
    )

# EC2 Instances
response = ec2.describe_instances()

instances = [
    instance
    for reservation in response["Reservations"]
    for instance in reservation["Instances"]
]

print(f"\nEC2 Instances ({len(instances)}):")
if not instances:
    print("  No EC2 instances found.")
else:
    for instance in instances:
        print(
            f"  {instance['InstanceId']} | "
            f"{instance['InstanceType']} | "
            f"{instance['State']['Name']}"
        )
