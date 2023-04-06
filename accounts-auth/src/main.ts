import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { microserviceConfig } from './microserviceConfig';
import { config } from 'dotenv';
config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.connectMicroservice(microserviceConfig);
  app.enableCors({origin: '*'})

  await app.startAllMicroservices();
  await app.listen(process.env.PORT);
}
bootstrap();
