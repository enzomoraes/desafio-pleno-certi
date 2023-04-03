import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { LogEntity, LogSchema } from './entities/log.entity';
import { LogsController } from './logs.controller';
import { LogsService } from './logs.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ schema: LogSchema, name: LogEntity.name }]),
  ],
  controllers: [LogsController],
  providers: [LogsService],
})
export class LogsModule {}
