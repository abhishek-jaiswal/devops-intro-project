import os
import boto.ec2

access_key = os.environ['AWS_ACCESS_KEY_ID']
secret_key = os.environ['AWS_SECRET_ACCESS_KEY']

def get_ec2_instances(region):
    ec2_conn = boto.ec2.connect_to_region(region,
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key)
    reservations = ec2_conn.get_all_reservations()
    for reservation in reservations:
        print region+':',reservation.instances

    for vol in ec2_conn.get_all_volumes():
        print region+':',vol.id


def main():
    regions = [
        'us-east-1',
        'us-east-2',
        'us-west-1',
        'us-west-2',
        'ca-central-1',
        'eu-west-1',
        'eu-west-2',
        'eu-central-1',
        'sa-east-1',
        'ap-southeast-1',
        'ap-southeast-2',
        'ap-northeast-1',
        'ap-northeast-2',
        'ap-south-1',
    ]
    
    for region in regions: get_ec2_instances(region)

if __name__ =='__main__':main()
