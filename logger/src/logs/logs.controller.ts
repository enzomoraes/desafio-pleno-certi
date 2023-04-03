import {
  Body,
  Controller,
  Get,
  OnModuleInit,
  Param,
  Post,
  Query,
  UsePipes,
} from '@nestjs/common';
import {
  Client,
  ClientKafka,
  EventPattern,
  Payload,
} from '@nestjs/microservices';
import { microserviceConfig } from '../microserviceConfig';
import { CreateLogValidatorPipe } from '../pipes/create-log-validator/create-log-validator.pipe';
import { CreateLogDto } from './dto/create-log.dto';
import { LogsService } from './logs.service';

@Controller()
export class LogsController implements OnModuleInit {
  constructor(private readonly logsService: LogsService) {}

  @Client(microserviceConfig)
  kafkaClient: ClientKafka;

  onModuleInit() {
    this.kafkaClient.subscribeToResponseOf('logs.create');
  }

  /**
   * This method listens to logs.create KAFKA topic
   * @param createLogDto
   * @returns
   */
  @EventPattern('logs.create')
  @UsePipes(CreateLogValidatorPipe)
  async createMessage(@Payload() createLogDto: CreateLogDto) {
    return this.logsService.create(createLogDto);
  }

  @Post('/logs')
  @UsePipes(CreateLogValidatorPipe)
  async create(@Body() createLogDto: CreateLogDto) {
    try {
      this.kafkaClient.send('logs.create', createLogDto).subscribe();
      return { message: 'published message' };
    } catch (error) {
      throw new Error('Could not publish message');
    }
  }

  @Get('/logs')
  findAll(@Query('orderDirection') orderDirection: -1 | 1 = -1) {
    return this.logsService.findAll(orderDirection);
  }

  @Get('/logs/:id')
  findOne(@Param('id') id: string) {
    return this.logsService.findOne(id);
  }
}
