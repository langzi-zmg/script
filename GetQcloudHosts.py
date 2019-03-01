from tencentcloud.common import credential
from tencentcloud.common.profile.client_profile import ClientProfile
from tencentcloud.common.profile.http_profile import HttpProfile
from tencentcloud.common.exception.tencent_cloud_sdk_exception import TencentCloudSDKException
from tencentcloud.cvm.v20170312 import cvm_client, models
import json
try:
    cred = credential.Credential("secretId", "secretKey")
    httpProfile = HttpProfile()
    httpProfile.endpoint = "cvm.tencentcloudapi.com"

    clientProfile = ClientProfile()
    clientProfile.httpProfile = httpProfile
    client = cvm_client.CvmClient(cred, "ap-shanghai", clientProfile)

    req = models.DescribeInstancesRequest()
    params = '{"Filters":[{"Name":"vpc-id","Values":["vpcid"]}],"Offset":0,"Limit":100}'
    req.from_json_string(params)

    resp = client.DescribeInstances(req)
    your_dict = json.loads(resp.to_json_string())
    instance = your_dict["InstanceSet"]
    print(len(instance))
    for i in instance:
        print(i["PrivateIpAddresses"][0]+"  "+i["InstanceName"])
except TencentCloudSDKException as err:
    print(err)