{
  region: 'ap-northeast-1',
  cluster: 'next-rails',
  service: 'nextjs',
  service_definition: 'ecs-service-def.jsonnet',
  task_definition: 'ecs-task-def.jsonnet',
  timeout: '10m0s',
  plugins: [
    {
      name: 'tfstate',
      config: {
        url: 'remote://app.terraform.io/matazou_organization/aws'
      }
    }
  ]
}
