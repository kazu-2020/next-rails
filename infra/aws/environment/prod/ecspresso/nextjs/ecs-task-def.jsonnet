{
  containerDefinitions: [
    {
      cpu: 0,
      essential: true,
      image: "{{ tfstate `aws_ecr_repository.app_next.repository_url` }}:proto2",
      logConfiguration: {
        logDriver: 'awslogs',
        options: {
          'awslogs-create-group': 'true',
          'awslogs-group': '/ecs/next-app',
          'awslogs-region': 'ap-northeast-1',
          'awslogs-stream-prefix': 'ecs',
          'max-buffer-size': '25m',
          mode: 'non-blocking',
        },
      },
      name: 'next',
      portMappings: [
        {
          appProtocol: 'http',
          containerPort: 3000,
          hostPort: 3000,
          name: 'next-3000-tcp',
          protocol: 'tcp',
        },
      ],
    },
  ],
  cpu: '1024',
  executionRoleArn: "{{ tfstate `aws_iam_role.ecs_task_execution.arn` }}",
  family: 'next-app',
  ipcMode: '',
  memory: '2048',
  networkMode: 'awsvpc',
  pidMode: '',
  requiresCompatibilities: [
    'FARGATE',
  ],
  runtimePlatform: {
    cpuArchitecture: 'X86_64',
    operatingSystemFamily: 'LINUX',
  },
}
