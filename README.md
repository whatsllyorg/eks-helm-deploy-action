# EKS deployments with Helm

GitHub action for deploying to AWS EKS clusters using helm.

## Customizing

### inputs

Following inputs can be used as `step.with` keys

| Name                    | Type   | Required | Description                                                                 |
|-------------------------|--------|----------|-----------------------------------------------------------------------------|
| `aws-access-key-id`     | String | Yes      | AWS access key id part of the AWS credentials. Used to login to EKS.        |
| `aws-secret-access-key` | String | Yes      | AWS secret access key part of the AWS credentials. Used to login to EKS.    |
| `aws-session-token`     | String | No       | AWS session token for temporary credentials (e.g. when using OIDC).         |
| `aws-region`            | String | Yes      | AWS region to use. Must match the region your cluster is in.                |
| `cluster-name`          | String | Yes      | The name of the EKS cluster.                                                |
| `cluster-role-arn`      | String | No       | If you wish to assume an admin role, provide the role ARN here.             |
| `config-files`          | String | No       | Comma-separated list of helm values files.                                  |
| `namespace`             | String | No       | Kubernetes namespace to use.                                                |
| `values`                | String | No       | Comma-separated list of value sets for helm. e.g: `key1=value1,key2=value2` |
| `name`                  | String | Yes      | The name of the helm release.                                               |
| `chart-path`            | String | Yes      | The path to the chart. (defaults to `helm/`)                                |
| `timeout`               | String | Yes      | Timeout for the helm upgrade (e.g. `5m`, `10m0s`). Defaults to `5m`.       |


## Example usage

```yaml
uses: z1digitalstudio/eks-helm-deploy-action@v2
with:
  aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
  aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  aws-region: us-west-2
  cluster-name: mycluster
  config-files: .github/values/dev.yaml
  chart-path: chart/
  namespace: dev
  values: key1=value1,key2=value2
  name: release_name
  timeout: 5m
```
