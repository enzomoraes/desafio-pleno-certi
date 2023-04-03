import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { UserEntity, UserSchema } from './entities/user.entity';
import { LoggerService } from 'src/logger/logger.service';
import { ClientKafka } from '@nestjs/microservices';

@Module({
  imports: [
    MongooseModule.forFeature([{ schema: UserSchema, name: UserEntity.name }]),
  ],
  controllers: [UsersController],
  providers: [UsersService, LoggerService, ClientKafka],
})
export class UsersModule {}
