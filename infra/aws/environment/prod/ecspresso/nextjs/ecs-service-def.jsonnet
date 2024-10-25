{
  capacityProviderStrategy: [
    {
      base: 1,
      capacityProvider: 'FARGATE_SPOT',
      weight: 100,
    },
  ],
  deploymentConfiguration: {
    alarms: {
      enable: false,
      rollback: false,
    },
    deploymentCircuitBreaker: {
      enable: true,
      rollback: true,
    },
    maximumPercent: 200,
    minimumHealthyPercent: 100,
  },
  deploymentController: {
    type: 'ECS',
  },
  desiredCount: 1,
  enableECSManagedTags: true,
  enableExecuteCommand: false,
  healthCheckGracePeriodSeconds: 0,
  launchType: '',
  loadBalancers: [
    {
      containerName: 'next',
      containerPort: 3000,
      targetGroupArn: "{{ tfstate `aws_alb_target_group.send_to_nextjs.arn` }}",
    },
  ],
  networkConfiguration: {
    awsvpcConfiguration: {
      assignPublicIp: 'ENABLED',
      securityGroups: [
        "{{ tfstate `aws_security_group.allow_traffic_from_alb.id` }}",
      ],
      subnets: [
        "{{ tfstate `aws_subnet.public_app_primary.id` }}",
        "{{ tfstate `aws_subnet.public_app_secondary.id` }}",
      ],
    },
  },
  platformFamily: 'Linux',
  platformVersion: 'LATEST',
  propagateTags: 'NONE',
  schedulingStrategy: 'REPLICA',
}
