import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { LoggerService } from './logger/logger.service';
import { MongooseModule } from '@nestjs/mongoose';
import { config } from 'dotenv';
import { ClientKafka } from '@nestjs/microservices';
import { JwtStrategyService } from './auth/jwt-strategy.service';
import { JwtGuard } from './auth/jwt.guard';
config();

@Module({
  imports: [
    MongooseModule.forRoot(
      `mongodb://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}`,
      {
        dbName: 'users-db',
      },
    ),
    UsersModule,
  ],
  controllers: [AppController],
  providers: [AppService, LoggerService, ClientKafka, JwtStrategyService, JwtGuard],
})
export class AppModule {}
